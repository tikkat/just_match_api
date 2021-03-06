# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::OwnedJobsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  let(:valid_session) do
    allow_any_instance_of(described_class).
      to(
        receive(:authenticate_user_token!).
        and_return(user)
      )
    {}
  end

  it 'assigns all jobs as @jobs' do
    job = FactoryGirl.create(:job, owner: user)
    get :index, { user_id: user.to_param }, valid_session
    expect(assigns(:jobs)).to eq([job])
  end

  it 'returns 401 for unauthorized user' do
    get :index, { user_id: user.to_param }, {}
    expect(response.status).to eq(401)
  end
end
