# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Api::V1::Users::ChatsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_session) do
    allow_any_instance_of(described_class).
      to(receive(:authenticate_user_token!).
      and_return(user))
    {}
  end

  describe 'GET #index' do
    context 'with valid params' do
      let(:valid_params) do
        { user_id: user.to_param }
      end

      it 'assigns all chats as @chats' do
        chat = FactoryGirl.create(:chat, users: [user])
        get :index, valid_params, valid_session
        expect(assigns(:chats)).to eq([chat])
      end
    end
  end

  describe 'GET #show' do
    context 'with valid params' do
      let(:chat) { FactoryGirl.create(:chat, users: [user]) }
      let(:valid_params) do
        { user_id: user.to_param, id: chat.to_param }
      end

      it 'assigns chat as @chat' do
        get :show, valid_params, valid_session
        expect(assigns(:chat)).to eq(chat)
      end
    end
  end
end
