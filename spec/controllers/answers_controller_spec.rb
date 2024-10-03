require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question:, user:) }
  let(:another_answer) { create(:answer, question: ) }

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

  describe 'PATCH #mark_as_best' do
    it 'marks the answer as the best' do
      patch :mark_as_best, params: { id: answer, question_id: question }, format: :js
      answer.reload

      expect(answer).to be_best
    end

    it 'renders mark_as_best template' do
      patch :mark_as_best, params: { id: answer, question_id: question }, format: :js
      expect(response).to render_template :mark_as_best
    end

    it 'unmarks the previous best answer' do
      patch :mark_as_best, params: { id: another_answer, question_id: question }, format: :js
      another_answer.reload
      expect(another_answer).to be_best

      patch :mark_as_best, params: { id: answer, question_id: question }, format: :js
      answer.reload
      another_answer.reload

      expect(answer).to be_best
      expect(another_answer).to_not be_best
    end
  end

  describe 'DELETE #delete_file' do
    let!(:answer) { create(:answer, :with_file) }
    let!(:file) { answer.files.first }

    it 'deletes the file' do
      expect { delete :delete_file, params: { id: answer, file_id: file.id }, format: :js }.to change(answer.files, :count).by(-1)
    end

    it 'rerenders show view' do
      delete :delete_file, params: { id: answer, file_id: file.id }, format: :js
      expect(response).to render_template :delete_file
    end
  end
end
