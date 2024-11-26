require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_file, user:) }
  let!(:file) { question.files.first }

  before { login(user) }

  describe 'DELETE #destroy' do
    it 'deletes the attachment' do
      expect { delete :destroy, params: { id: file }, format: :js }.to change(ActiveStorage::Attachment, :count).by(-1)
    end

    it 'redirects to question show view' do
      delete :destroy, params: { id: file }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
