# frozen_string_literal: true
module Index
  class UsersIndex < BaseIndex
    SORTABLE_FIELDS = %i(created_at first_name last_name).freeze

    def users(scope = User)
      @users ||= begin
        scope_includes = %i(language languages company chats)

        prepare_records(scope.includes(*scope_includes))
      end
    end
  end
end
