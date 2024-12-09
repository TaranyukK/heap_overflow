require 'rails_helper'

RSpec.describe SearchService, type: :service do
  let(:query) { 'search term' }
  let(:model) { nil }

  let(:search_service) { described_class.new(query, model) }

  describe '#call' do
    context 'when no model is provided' do
      before do
        allow(Question).to receive(:search).with(query).and_return(['question1'])
        allow(Answer).to receive(:search).with(query).and_return(['answer1'])
        allow(Comment).to receive(:search).with(query).and_return(['comment1'])
        allow(User).to receive(:search).with(query).and_return(['user1'])
      end

      it 'calls search on each model' do
        search_service.call

        expect(Question).to have_received(:search).with(query)
        expect(Answer).to have_received(:search).with(query)
        expect(Comment).to have_received(:search).with(query)
        expect(User).to have_received(:search).with(query)
      end

      it 'returns the search results for all models' do
        result = search_service.call

        expect(result).to eq(%w[question1 answer1 comment1 user1])
      end
    end

    context 'when a specific model is provided' do
      let(:model) { 'Question' }

      before do
        allow(Question).to receive(:search).with(query).and_return(['question1'])
        allow(Answer).to receive(:search).with(query).and_return(['answer1'])
        allow(Comment).to receive(:search).with(query).and_return(['comment1'])
        allow(User).to receive(:search).with(query).and_return(['user1'])
      end

      it 'calls search only on the specified model' do
        search_service.call

        expect(Question).to have_received(:search).with(query)
        expect(Answer).not_to have_received(:search)
        expect(Comment).not_to have_received(:search)
        expect(User).not_to have_received(:search)
      end

      it 'returns search results for the specified model' do
        result = search_service.call

        expect(result).to eq(['question1'])
      end
    end
  end
end
