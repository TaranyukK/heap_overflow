require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question:, user:) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid params' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }
          .to change(Answer, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid params' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }
          .to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'edited answer' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'edited answer'
      end

      it 'renders updated view' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'edited answer' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid params' do
      it 'does not change answer' do
        expect do
          patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders edit template' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'redirects to question show view' do
      delete :destroy, params: { question_id: question, id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
