require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user:) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    it 'return true if the user is author' do
      expect(user).to be_author(question)
    end

    it 'return false if the user is not author' do
      expect(other_user).not_to be_author(question)
    end
  end

  describe '.find_for_auth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { instance_double(FindForOauthService) }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      described_class.find_for_oauth(auth)
    end
  end

  describe '#subscribed?' do
    let!(:subscription) { create(:subscription, user:, question:) }

    it 'user subscribed' do
      expect(user).to be_subscribed question
    end

    it 'other_user does not subscribed' do
      expect(other_user).not_to be_subscribed question
    end
  end
end
