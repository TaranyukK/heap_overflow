require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:author) { create(:user) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  let(:votable) do
    voted(model, author)
  end

  describe 'Associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe '#vote_up' do
    it 'votes up' do
      votable.vote_up(user1)

      expect(votable.rating).to eq(1)
    end

    it 'vote up second time' do
      votable.vote_up(user1)
      votable.vote_up(user1)

      expect(votable.rating).to eq(0)
    end

    it 'author cannot vote up' do
      votable.vote_up(author)

      expect(votable.rating).to eq(0)
    end
  end

  describe '#vote_down' do
    it 'votes down' do
      votable.vote_down(user1)

      expect(votable.rating).to eq(-1)
    end

    it 'vote down second time' do
      votable.vote_down(user1)
      votable.vote_down(user1)

      expect(votable.rating).to eq(0)
    end

    it 'author cannot vote down' do
      votable.vote_down(author)

      expect(votable.rating).to eq(0)
    end
  end

  describe '#rating' do
    let!(:first_vote) { create(:vote, user: user1, votable:) }
    let!(:second_vote) { create(:vote, user: user2, votable:) }

    it 'total vote sum' do
      expect(votable.rating).to eq(2)
    end
  end
end
