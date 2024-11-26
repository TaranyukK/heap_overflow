require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_link, user:) }
  let!(:link) { question.links.first }

  before { login(user) }

  describe 'DELETE #destroy' do
    it 'deletes link' do
      expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
    end

    it 'redirects to question show view' do
      delete :destroy, params: { id: link }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
