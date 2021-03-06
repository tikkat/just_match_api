# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SkillDashboard do
  subject { described_class.new }

  let(:skill) { mock_model(Skill, name: 'Skill', id: 1) }

  describe '#display_resource' do
    it 'returns the correct display name' do
      expect(subject.display_resource(skill)).to eq('#1 Skill')
    end
  end
end
