require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'return true if the user is author' do
      expect(user).to be_author(question)
    end

    it 'return false if the user is not author' do
      expect(user2).not_to be_author(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    context 'user already has authorization' do
      it 'returns user' do
        user.authorizations.create(provider: 'github', uid: '123456')

        expect(described_class.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { described_class.find_for_oauth(auth) }.not_to change(described_class, :count)
        end

        it 'creates new authorization for user' do
          expect { described_class.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates new authorization with provider and uid' do
          authorization = described_class.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(described_class.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new_user@example.com' })
        end

        it 'creates new user' do
          expect { described_class.find_for_oauth(auth) }.to change(described_class, :count).by(1)
        end

        it 'returns user' do
          expect(described_class.find_for_oauth(auth)).to be_a described_class
        end

        it 'fills user email' do
          user = described_class.find_for_oauth(auth)

          expect(user.email).to eq 'new_user@example.com'
        end

        it 'creates authorization for user' do
          user = described_class.find_for_oauth(auth)

          expect(user.authorizations).not_to be_empty
        end

        it 'creates new authorization with provider and uid' do
          authorization = described_class.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
