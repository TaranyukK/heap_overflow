require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid params' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid params' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid params' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js

        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }, format: :js
        question.reload

        expect(question.title).to eq 'New title'
        expect(question.body).to eq 'New body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid params' do
      it 'does not change question' do
        expect do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end.to_not change(question, :title)
      end

      it 're-renders edit view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question) }

    it 'deletes the question' do
      expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'redirects to index' do
      delete :destroy, params: { id: question }

      expect(response).to redirect_to questions_path
    end
  end

  describe 'DELETE #delete_file' do
    before { login(user) }

    let!(:question) { create(:question, :with_file) }
    let!(:file) { question.files.first }

    it 'deletes the file' do
      expect { delete :delete_file, params: { id: question, file_id: file.id }, format: :js }.to change(question.files, :count).by(-1)
    end

    it 'rerenders show view' do
      delete :delete_file, params: { id: question, file_id: file.id }, format: :js
      expect(response).to render_template :delete_file
    end
  end
end
