shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      send(method, api_path, headers: headers)
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 status if access_token is invalid' do
      send(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
