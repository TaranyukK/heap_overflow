require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user:) }
    let(:create_subscription) { post :create, params: { question_id: question.id }, format: :js }

    before { login(user) }

    it 'saves a new subscription to the database' do
      expect { create_subscription }.to change(question.subscriptions, :count).by(1)
    end

    it 'new subscription belongs to the logged user' do
      create_subscription

      expect(question.subscriptions.last.user).to eq user
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user:) }
    let!(:subscription) { create(:subscription, user:, question:) }
    let(:delete_subscription) { delete :destroy, params: { id: subscription }, format: :js }

    before { login user }

    it 'deletes subscription from user' do
      expect { delete_subscription }.to change(user.subscriptions, :count).by(-1)
    end

    it 'deletes subscription from question' do
      expect { delete_subscription }.to change(question.subscriptions, :count).by(-1)
    end
  end
end
