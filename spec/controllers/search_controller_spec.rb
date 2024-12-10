require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user:) }
  let!(:answer) { create(:answer, question:, user:) }
  let!(:comment) { create(:comment, commentable: question, user:) }

  before { login(user) }

  describe 'GET #index' do
    context 'with valid query' do
      let(:search_results) { [question, answer, comment, user] }

      before do
        allow(SearchService).to receive(:new).with('My', nil).and_return(double(call: search_results))
        get :index, params: { query: 'My' }
      end

      it 'initializes the search service with correct parameters' do
        expect(SearchService).to have_received(:new).with('My', nil)
      end

      it 'assigns the result of the search to @results' do
        expect(assigns(:results)).to eq(search_results)
      end

      it 'renders the index view' do
        expect(response).to render_template :index
      end
    end

    context 'with empty query' do
      before do
        allow(SearchService).to receive(:new).with('', nil).and_return(double(call: []))
        get :index, params: { query: '' }
      end

      it 'does not call SearchService with empty query' do
        expect(SearchService).to have_received(:new).with('', nil)
      end

      it 'assigns an empty result to @results' do
        expect(assigns(:results)).to eq([])
      end

      it 'renders the index view' do
        expect(response).to render_template :index
      end
    end

    context 'with model-specific query' do
      let(:search_results) { [question] }

      before do
        allow(SearchService).to receive(:new).with('My', 'Question').and_return(double(call: search_results))
        get :index, params: { query: 'My', model: 'Question' }
      end

      it 'searches only questions when model is Question' do
        expect(assigns(:results)).to eq(search_results)
      end

      it 'initializes the search service with correct parameters' do
        expect(SearchService).to have_received(:new).with('My', 'Question')
      end
    end
  end
end
