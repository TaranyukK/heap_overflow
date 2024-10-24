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
end
