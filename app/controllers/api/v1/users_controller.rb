# frozen_string_literal: true
module Api
  module V1
    class UsersController < BaseController
      SET_USER_ACTIONS = [:show, :edit, :update, :destroy, :matching_jobs, :jobs].freeze
      before_action :set_user, only: SET_USER_ACTIONS

      before_action :require_promo_code, except: [:company_users_count]
      after_action :verify_authorized, except: [:company_users_count]

      resource_description do
        short 'API for managing users'
        name 'Users'
        description ''
        formats [:json]
        api_versions '1.0'
      end

      ALLOWED_INCLUDES = %w(language languages company user_images).freeze

      def company_users_count
        users_count = ENV.fetch(
          'CURRENT_COMPANY_USERS_COUNT',
          User.company_users.count
        ).to_i

        render json: { count: users_count }
      end

      api :GET, '/users', 'List users'
      description 'Returns a list of users if the user is allowed.'
      ApipieDocHelper.params(self, Index::UsersIndex)
      example Doxxer.read_example(User, plural: true)
      def index
        authorize(User)

        users_index = Index::UsersIndex.new(self)
        @users = users_index.users

        api_render(@users, total: users_index.count)
      end

      api :GET, '/users/:id', 'Show user'
      description 'Returns user is allowed to.'
      error code: 404, desc: 'Not found'
      ApipieDocHelper.params(self)
      example Doxxer.read_example(User)
      def show
        authorize(@user)

        api_render(@user)
      end

      api :POST, '/users/', 'Create new user'
      description 'Creates and returns a new user.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'User attributes', required: true do
          # rubocop:disable Metrics/LineLength
          param :'skill-ids', Array, of: Integer, desc: 'List of skill ids'
          param :'first-name', String, desc: 'First name', required: true
          param :'last-name', String, desc: 'Last name', required: true
          param :description, String, desc: 'Description'
          param :'job-experience', String, desc: 'Job experience'
          param :education, String, desc: 'Education'
          param :'competence-text', String, desc: 'Competences'
          param :email, String, desc: 'Email', required: true
          param :phone, String, desc: 'Phone', required: true
          param :street, String, desc: 'Street'
          param :zip, String, desc: 'Zip code'
          param :ssn, String, desc: 'Social Security Number (10 characters)', required: true
          param :'ignored-notifications', Array, desc: "List of ignored notifications, any of #{User::NOTIFICATIONS.to_sentence}"
          param :'company-id', Integer, desc: 'Company id for user'
          param :'language-id', Integer, desc: 'Primary language id for user', required: true
          param :'language-ids', Array, of: Hash, desc: 'Languages that the user knows', required: true do
            param :id, Integer, desc: 'Language id', required: true
            param :proficiency, UserLanguage::PROFICIENCY_RANGE.to_a, desc: 'Language proficiency'
          end
          param :'user-image-one-time-token', String, desc: 'User image one time token'
          param :'current-status', User::STATUSES.keys, desc: 'Current status'
          param :'at-und', User::AT_UND.keys, desc: 'AT-UND status'
          param :'arrived-at', String, desc: 'Arrived at date'
          param :'country-of-origin', String, desc: 'Country of origin (alpha-2 code)'
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.read_example(User, method: :create)
      def create
        @user = User.new(user_params)

        authorize(@user)

        if @user.save
          login_user(@user)

          @user.skills = Skill.where(id: user_params[:skill_ids])
          @user.profile_image_token = jsonapi_params[:user_image_one_time_token]

          user_languages_params = normalize_language_ids(jsonapi_params[:language_ids])
          @user.user_languages = user_languages_params.map do |attrs|
            UserLanguage.new(
              language_id: attrs[:id],
              proficiency: attrs[:proficiency]
            )
          end

          UserWelcomeNotifier.call(user: @user)

          api_render(@user, status: :created)
        else
          api_render_errors(@user)
        end
      end

      api :PATCH, '/users/', 'Update new user'
      description 'Updates and returns the updated user if the user is allowed.'
      error code: 400, desc: 'Bad request'
      error code: 422, desc: 'Unprocessable entity'
      error code: 401, desc: 'Unauthorized'
      param :data, Hash, desc: 'Top level key', required: true do
        param :attributes, Hash, desc: 'User attributes', required: true do
          # rubocop:disable Metrics/LineLength
          param :'first-name', String, desc: 'First name'
          param :'last-name', String, desc: 'Last name'
          param :description, String, desc: 'Description'
          param :'job-experience', String, desc: 'Job experience'
          param :education, String, desc: 'Education'
          param :'competence-text', String, desc: 'Competences'
          param :email, String, desc: 'Email'
          param :phone, String, desc: 'Phone'
          param :street, String, desc: 'Street'
          param :zip, String, desc: 'Zip code'
          param :ssn, String, desc: 'Social Security Number (10 characters)'
          param :'ignored-notifications', Array, desc: "List of ignored notifications, any of #{User::NOTIFICATIONS.to_sentence}"
          param :'language-id', Integer, desc: 'Primary language id for user'
          param :'company-id', Integer, desc: 'Company id for user'
          param :'user-image-one-time-token', String, desc: 'User image one time token'
          param :'current-status', User::STATUSES.keys, desc: 'Current status'
          param :'at-und', User::AT_UND.keys, desc: 'AT-UND status'
          param :'arrived-at', String, desc: 'Arrived at date'
          param :'country-of-origin', String, desc: 'Country of origin'
          # rubocop:enable Metrics/LineLength
        end
      end
      example Doxxer.read_example(User, method: :update)
      def update
        authorize(@user)

        if @user.update(user_params)
          @user.profile_image_token = jsonapi_params[:user_image_one_time_token]

          api_render(@user)
        else
          api_render_errors(@user)
        end
      end

      api :DELETE, '/users/:id', 'Delete user'
      description 'Deletes user user if the user is allowed.'
      error code: 401, desc: 'Unauthorized'
      error code: 404, desc: 'Not found'
      def destroy
        authorize(@user)

        @user.reset!
        head :no_content
      end

      api :GET, '/users/:id/matching_jobs', 'Show matching jobs for user'
      description 'Returns the matching jobs for user if the user is allowed.'
      error code: 401, desc: 'Unauthorized'
      error code: 404, desc: 'Not found'
      def matching_jobs
        authorize(@user)

        render json: Job.uncancelled.matches_user(@user)
      end

      api :GET, '/users/notifications', 'Show all possible user notifications'
      description 'Returns a list of all possible user notifications.'
      example "# Example response
#{JSON.pretty_generate(UserNotificationsSerializer.serializeble_resource.to_h)}"
      def notifications
        authorize(User)

        resource = UserNotificationsSerializer.serializeble_resource

        render json: resource
      end

      private

      def normalize_language_ids(language_ids)
        return [] if language_ids.nil?

        language_ids.map do |lang|
          if lang.is_a?(Hash)
            lang
          else
            message = [
              'Passing languages as a list of integers is deprecated.',
              'Please pass an array of objects, i.e [{ id: 1, proficiency: 1 }]'
            ].join(' ')
            ActiveSupport::Deprecation.warn(message)

            { id: lang, proficiency: nil }
          end
        end
      end

      def set_user
        @user = User.find(params[:user_id])
      end

      def user_params
        whitelist = [
          :first_name, :last_name, :email, :phone, :description, :job_experience,
          :education, :ssn, :street, :zip, :language_id, :password, :company_id,
          :competence_text, :current_status, :at_und, :arrived_at, :country_of_origin,
          ignored_notifications: [], skill_ids: []
        ]
        jsonapi_params.permit(*whitelist)
      end
    end
  end
end
