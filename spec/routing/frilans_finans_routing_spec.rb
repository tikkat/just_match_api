# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::FrilansFinansController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      path = '/api/v1/users/1/frilans-finans'
      route_path = 'api/v1/users/frilans_finans#create'
      expect(post: path).to route_to(route_path, user_id: '1')
    end
  end
end
