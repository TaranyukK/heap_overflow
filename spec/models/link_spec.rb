require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value('https://www.google.com').for(:url) }
  it { should_not allow_value('www.google.com').for(:url) }

  describe 'gist_url?' do
    let(:question) { create(:question) }

    context 'when url is a gist url' do
      let(:link) { create(:link, linkable: question, url: 'https://gist.github.com/username/some_id') }

      it 'returns true' do
        expect(link.gist_url?).to be_truthy
      end
    end

    context 'when url is not a gist url' do
      let(:link) { create(:link, linkable: question, url: 'https://example.com') }

      it 'returns false' do
        expect(link.gist_url?).to be_falsey
      end
    end
  end
end
