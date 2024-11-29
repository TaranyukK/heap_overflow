require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user:) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question:, user:) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq question.user.id
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user:) }
    let!(:answer) { create(:answer, question:, user:) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user:) }
      let!(:links) { create_list(:link, 3, linkable: answer) }
      let!(:files) do
        answer.files.attach(
          io:       Rails.root.join('spec/rails_helper.rb').open,
          filename: 'rails_helper.rb'
        )
        answer.files.attach(
          io:       Rails.root.join('spec/spec_helper.rb').open,
          filename: 'spec_helper.rb'
        )
      end
      let(:api_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all public fields for answer' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(api_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains associated comments, links, and files' do
        expect(api_response['comments'].size).to eq 3
        expect(api_response['links'].size).to eq 3
        expect(api_response['files'].size).to eq answer.files.size
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user:) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:api_response) { json['answer'] }

      context 'with valid params' do
        before do
          post api_path, params: { access_token: access_token.token, answer: { body: 'new body' } }
        end

        it 'returns answer' do
          expect(api_response['body']).to eq 'new body'
          expect(api_response['user_id']).to eq user.id.as_json
        end
      end

      context 'with invalid params' do
        before do
          post api_path, params: { access_token: access_token.token, answer: { body: nil } }
        end

        it 'returns error message' do
          expect(json['errors']).to eq ["Body can't be blank"]
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user:) }
    let!(:answer) { create(:answer, question:, user:) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:api_response) { json['answer'] }

      context 'with valid params' do
        before do
          patch api_path, params: { access_token: access_token.token, answer: { body: 'updated body' } }
        end

        it 'returns updated answer' do
          expect(api_response['body']).to eq 'updated body'
        end
      end

      context 'with invalid params' do
        before do
          patch api_path, params: { access_token: access_token.token, answer: { body: nil } }
        end

        it "doesn't change answer and returns error message" do
          expect(json['errors']).to include("Body can't be blank")
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user:) }
    let!(:answer) { create(:answer, question:, user:) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'deletes answer' do
        expect { delete api_path, params: { access_token: access_token.token } }
          .to change(Answer, :count).by(-1)
      end
    end
  end
end
