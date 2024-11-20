require 'rails_helper'

RSpec.describe FindForOauthService do
  subject { described_class.new(auth) }

  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

  context 'user already has authorization' do
    it 'returns user' do
      user.authorizations.create(provider: 'github', uid: '123456')

      expect(subject.call).to eq user
    end
  end

  context 'user has no authorization' do
    context 'user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }

      it 'does not create new user' do
        expect { subject.call }.not_to change(User, :count)
      end

      it 'creates new authorization for user' do
        expect { subject.call }.to change(user.authorizations, :count).by(1)
      end

      it 'creates new authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns user' do
        expect(subject.call).to eq user
      end
    end

    context 'user does not exist' do
      let(:auth) do
        OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new_user@example.com' })
      end

      it 'creates new user' do
        expect { subject.call }.to change(User, :count).by(1)
      end

      it 'returns user' do
        expect(subject.call).to be_a User
      end

      it 'fills user email' do
        user = subject.call

        expect(user.email).to eq 'new_user@example.com'
      end

      it 'creates authorization for user' do
        user = subject.call

        expect(user.authorizations).not_to be_empty
      end

      it 'creates new authorization with provider and uid' do
        authorization = subject.call.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
