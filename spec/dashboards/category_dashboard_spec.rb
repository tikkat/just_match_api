# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CategoryDashboard do
  subject { described_class.new }

  let(:category) { mock_model(Category, name: 'Category', id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(category)).to eq('#1 Category')
    end
  end
end
