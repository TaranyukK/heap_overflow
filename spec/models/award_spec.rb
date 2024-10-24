require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:user).optional }
  it { should belong_to(:question) }

  it { should validate_presence_of(:title) }

  describe 'validations' do
    let(:question) { create(:question) }
    let(:award) { build(:award, question:) }

    it 'is valid with an attached image' do
      award.image.attach(io: Rails.root.join('spec/fixtures/1x1.png').open, filename: '1x1.png',
                         content_type: 'image/png')
      expect(award).to be_valid
    end

    it 'is invalid with wrong image type' do
      award.image.attach(io: Rails.root.join('spec/fixtures/1x1.svg').open, filename: '1x1.svg',
                         content_type: 'image/svg')
      expect(award).not_to be_valid
      expect(award.errors[:image]).to include('must be a PNG, JPG or JPEG')
    end

    it 'is invalid without an image' do
      award.image = nil
      expect(award).not_to be_valid
      expect(award.errors[:image]).to include('must be attached')
    end
  end
end
