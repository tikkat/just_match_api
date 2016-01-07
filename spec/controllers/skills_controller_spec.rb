require 'rails_helper'

RSpec.describe Api::V1::SkillsController, type: :controller do
  let(:valid_attributes) do
    FactoryGirl.create(:user_admin)
    lang_id = FactoryGirl.create(:language).id
    { name: "Skill #{SecureRandom.uuid}", language_id: lang_id }
  end

  let(:invalid_attributes) do
    { name: nil }
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all skills as @skills' do
      skill = Skill.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:skills)).to eq([skill])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested skill as @skill' do
      skill = Skill.create! valid_attributes
      get :show, { id: skill.to_param }, valid_session
      expect(assigns(:skill)).to eq(skill)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        expect do
          post :create, { skill: valid_attributes }, valid_session
        end.to change(Skill, :count).by(1)
      end

      it 'assigns a newly created skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, { skill: valid_attributes }, valid_session
        expect(assigns(:skill)).to be_a(Skill)
        expect(assigns(:skill)).to be_persisted
      end

      it 'returns success status' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, { skill: valid_attributes }, valid_session
        expect(response.status).to eq(201)
      end

      context 'unauthorized user' do
        it 'returns unauthorized status' do
          allow_any_instance_of(User).to receive(:admin?).and_return(false)
          post :create, { skill: valid_attributes }, valid_session
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, { skill: invalid_attributes }, valid_session
        expect(assigns(:skill)).to be_a_new(Skill)
      end

      it 'returns 422' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        post :create, { skill: invalid_attributes }, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'New skill name' }
      end

      it 'updates the requested skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = Skill.create! valid_attributes
        put :update, { id: skill.to_param, skill: new_attributes }, valid_session
        skill.reload
        expect(skill.name).to eq('New skill name')
      end

      it 'assigns the requested skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = Skill.create! valid_attributes
        put :update, { id: skill.to_param, skill: valid_attributes }, valid_session
        expect(assigns(:skill)).to eq(skill)
      end

      it 'returns 200' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = Skill.create! valid_attributes
        put :update, { id: skill.to_param, skill: valid_attributes }, valid_session
        expect(response.status).to eq(200)
      end

      context 'unauthorized user' do
        it 'returns unauthorized status' do
          skill = Skill.create! valid_attributes
          allow_any_instance_of(User).to receive(:admin?).and_return(false)
          post :update, { id: skill.to_param, skill: valid_attributes }, valid_session
          expect(response.status).to eq(401)
        end
      end
    end

    context 'with invalid params' do
      it 'assigns the skill as @skill' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = Skill.create! valid_attributes
        put :update, { id: skill.to_param, skill: invalid_attributes }, valid_session
        expect(assigns(:skill)).to eq(skill)
      end

      it 'returns 422' do
        allow_any_instance_of(User).to receive(:admin?).and_return(true)
        skill = Skill.create! valid_attributes
        put :update, { id: skill.to_param, skill: invalid_attributes }, valid_session
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested skill' do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      skill = Skill.create! valid_attributes
      expect do
        delete :destroy, { id: skill.to_param }, valid_session
      end.to change(Skill, :count).by(-1)
    end

    it 'redirects to the skills list' do
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
      skill = Skill.create! valid_attributes
      delete :destroy, { id: skill.to_param }, valid_session
      expect(response.status).to eq(204)
    end

    context 'unauthorized user' do
      it 'returns unauthorized status' do
        skill = Skill.create! valid_attributes
        allow_any_instance_of(User).to receive(:admin?).and_return(false)
        delete :destroy, { id: skill.to_param, skill: valid_attributes }, valid_session
        expect(response.status).to eq(401)
      end
    end
  end
end
