require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question:) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq(2)
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq(3)
        end

        it 'returns all public fields' do
          %w[id rating body user_id best created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user:) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, commentable: question, user:) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      let!(:files) do
        question.files.attach(
          io:       Rails.root.join('spec/rails_helper.rb').open,
          filename: 'rails_helper.rb'
        )
        question.files.attach(
          io:       Rails.root.join('spec/spec_helper.rb').open,
          filename: 'spec_helper.rb'
        )
      end

      let(:api_response) { json['question'] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all public fields for question' do
        %w[id rating title body user_id created_at updated_at].each do |attr|
          expect(api_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains associated comments, links, and files' do
        expect(api_response['comments'].count).to eq 3
        expect(api_response['links'].count).to eq 3
        expect(api_response['files'].count).to eq question.files.count
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:api_response) { json['question'] }

      context 'request with valid params' do
        before do
          post api_path,
               params: { access_token: access_token.token, question: { title: 'new title', body: 'new body' } }
        end

        it 'returns created question' do
          expect(api_response['title']).to eq 'new title'
          expect(api_response['body']).to eq 'new body'
          expect(api_response['user_id']).to eq user.id.as_json
        end

        it 'creates a new question in the database' do
          expect(Question.count).to eq 1
        end
      end

      context 'request with invalid params' do
        before { post api_path, params: { access_token: access_token.token, question: { title: nil, body: nil } } }

        it 'returns error messages' do
          expect(json['errors']).to eq({ 'body' => ["can't be blank"], 'title' => ["can't be blank"] })
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user:) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:api_response) { json['question'] }

      context 'request with valid params' do
        before do
          patch api_path,
                params: { access_token: access_token.token, question: { title: 'updated title', body: 'updated body' } }
        end

        it 'updates the question' do
          expect(api_response['title']).to eq 'updated title'
          expect(api_response['body']).to eq 'updated body'
          expect(api_response['user_id']).to eq user.id.as_json
        end

        it 'saves changes in the database' do
          question.reload
          expect(question.title).to eq 'updated title'
          expect(question.body).to eq 'updated body'
        end
      end

      context 'request with invalid params' do
        before { patch api_path, params: { access_token: access_token.token, question: { title: nil, body: nil } } }

        it "doesn't change question and returns error messages" do
          expect(json['errors']).to include("Title can't be blank", "Body can't be blank")
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user:) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'deletes the question' do
        expect { delete api_path, params: { access_token: access_token.token } }.to change(Question, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: { access_token: access_token.token }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
