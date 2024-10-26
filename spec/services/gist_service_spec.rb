require 'rails_helper'

RSpec.describe GistService do
  let(:link) { 'https://gist.github.com/TaranyukK/8502ae3e21f1fd387002c9050e436867' }
  let(:invalid_link) { 'https://gist.github.com/TaranyukK/invalid_url' }

  describe 'get gist content' do
    it 'return array of gist content' do
      expect(described_class.new(link).call).to eq ['This is the test!']
    end

    it 'return nil for invalid link' do
      expect(described_class.new(invalid_link).call).to eq ['Not found']
    end
  end
end
