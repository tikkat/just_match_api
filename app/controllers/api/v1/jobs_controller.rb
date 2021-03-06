# frozen_string_literal: true
module Api
  module V1
    class JobsController < BaseController
      before_action :set_job, only: [:show, :edit, :update, :matching_users]

      resource_description do
        short 'API for managing jobs'
        name 'Jobs'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      ALLOWED_INCLUDES = %w(owner company language category hourly_pay comments).freeze

      api :GET, '/jobs', 'List jobs'
      description 'Returns a list of jobs.'
      ApipieDocHelper.params(self, Index::JobsIndex)
      example Doxxer.read_example(Job, plural: true)
      def index
        authorize(Job)

        # NOTE: N+1 Query
        #   Causes N+1 for job_users resource if current user is owner
        #     :includes => [:job_users]

        jobs_index = Index::JobsIndex.new(self)
        jobs_scope = jobs_index_scope(Job.uncancelled)
        @jobs = jobs_index.jobs(jobs_scope)

        api_render(@jobs, total: jobs_index.count)
      end

      api :GET, '/jobs/:id', 'Show job'
      description 'Return job.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(Job)
      def show
        authorize(@job)

        api_render(@job)
      end

      api :POST, '/jobs/', 'Create new job'
      description 'Creates and returns new job.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Job attributes', required: true do
          # rubocop:disable Metrics/LineLength
          param :hours, Float, desc: 'Estmiated completion time', required: true
          param :name, String, desc: 'Name', required: true
          param :'short-description', String, desc: 'Short description'
          param :description, String, desc: 'Description', required: true
          param :'job-date', String, desc: 'Job start date', required: true
          param :'job-end-date', String, desc: 'Job end date', required: true
          param :'language-id', Integer, desc: 'Langauge id of the text content', required: true
          param :'hourly-pay-id', Integer, desc: 'Hourly pay id', required: true
          param :'skill-ids', Array, of: Integer, desc: 'List of skill ids', required: true
          # rubocop:enable Metrics/LineLength
        end
      end
      ApipieDocHelper.params(self)
      example Doxxer.read_example(Job, method: :create)
      def create
        authorize(Job)

        @job = Job.new(permitted_attributes)
        @job.owner_user_id = current_user.id

        if @job.save
          @job.skills = Skill.where(id: jsonapi_params[:skill_ids])

          owner = @job.owner
          User.matches_job(@job, strict_match: true).each do |user|
            UserJobMatchNotifier.call(user: user, job: @job, owner: owner)
          end

          api_render(@job, status: :created)
        else
          api_render_errors(@job)
        end
      end

      api :PATCH, '/jobs/:id', 'Update job'
      description 'Updates and returns the updated job.'
      error code: 400, desc: 'Bad request'
      error code: 401, desc: 'Unauthorized'
      error code: 403, desc: 'Forbidden'
      error code: 404, desc: 'Not found'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'Job attributes', required: true do
          param :name, String, desc: 'Name'
          param :'short-description', String, desc: 'Short description'
          param :description, String, desc: 'Description'
          param :'job-date', String, desc: 'Job start date'
          param :'job-end-date', String, desc: 'Job end date'
          param :hours, Float, desc: 'Estmiated completion time'
          param :cancelled, [true], desc: 'Cancel the job'
          param :'language-id', Integer, desc: 'Langauge id of the text content'
          param :'hourly-pay-id', Integer, desc: 'Hourly pay id'
          param :'owner-user-id', Integer, desc: 'User id for the job owner'
        end
      end
      example Doxxer.read_example(Job, method: :update)
      def update
        authorize(@job)

        @job.assign_attributes(permitted_attributes)
        if @job.locked_for_changes?
          message = I18n.t('errors.job.update_not_allowed_when_accepted')
          errors = JsonApiErrors.new
          errors.add(status: 403, detail: message)

          render json: errors, status: :forbidden
          return
        end

        notifier_klass = NilNotifier
        if @job.send_cancelled_notice?
          notifier_klass = JobCancelledNotifier
        end

        if @job.save
          notifier_klass.call(job: @job)

          api_render(@job)
        else
          api_render_errors(@job)
        end
      end

      api :GET, '/jobs/:job_id/matching_users', 'Show matching users for job'
      description 'Returns matching users for job if user is allowed.'
      error code: 401, desc: 'Unauthorized'
      error code: 404, desc: 'Not found'
      def matching_users
        authorize(@job)

        render json: User.matches_job(@job)
      end

      private

      def set_job
        @job = policy_scope(Job).find(params[:job_id])
      end

      def job_policy
        policy(@job || Job.new)
      end

      def jobs_index_scope(base_scope)
        if included_resource?(:comments)
          base_scope = base_scope.includes(comments: [:owner, :language])
        end

        base_scope = base_scope.includes(:hourly_pay) if included_resource?(:hourly_pay)
        base_scope = base_scope.includes(:category) if included_resource?(:category)
        base_scope = base_scope.includes(:language) if included_resource?(:language)

        if included_resource?(:company)
          base_scope = base_scope.includes(company: [:company_images])
        end

        if included_resource?(:owner)
          base_scope = base_scope.includes(owner: [:user_images])
        end

        base_scope
      end

      def permitted_attributes
        jsonapi_params.permit(job_policy.permitted_attributes)
      end
    end
  end
end
