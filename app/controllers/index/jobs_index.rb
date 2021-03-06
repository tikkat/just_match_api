# frozen_string_literal: true
module Index
  class JobsIndex < BaseIndex
    TRANSFORMABLE_FILTERS = TRANSFORMABLE_FILTERS.merge(job_date: :date_range).freeze
    ALLOWED_FILTERS = %i(id hours created_at job_date verified filled).freeze
    SORTABLE_FIELDS = %i(hours job_date name verified created_at updated_at).freeze

    def jobs(scope = Job)
      @jobs ||= begin
        include_scopes = [:language, :company, :category, :hourly_pay]
        include_scopes << user_include_scopes(user_key: :owner)

        prepare_records(scope.includes(*include_scopes))
      end
    end
  end
end
