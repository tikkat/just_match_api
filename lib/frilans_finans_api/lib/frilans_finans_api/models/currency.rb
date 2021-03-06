# frozen_string_literal: true

module FrilansFinansApi
  class Currency
    include Walker

    def self.index(page: 1, client: FrilansFinansApi.client_klass.new)
      response = client.currencies(page: page)
      Document.new(response.body)
    end
  end
end
