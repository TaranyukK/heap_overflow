require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json).not_to have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:other_users) { create_list(:user, 3) }
      let(:other_user) { other_users.first }
      let(:other_user_response) { json.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns list of users excluding current user' do
        expect(json.size).to eq 3
        json.each do |user|
          expect(user['id']).not_to eq me.id
        end
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(other_user_response[attr]).to eq other_user.send(attr).as_json
        end
      end
    end
  end
end
