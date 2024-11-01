require 'rails_helper'

shared_examples_for 'voted' do
  describe 'POST #vote_up' do
    context 'User' do
      before { login(user) }

      it 'vote up' do
        expect { post :vote_up, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(1)
      end
    end

    context 'Author' do
      before { login(author) }

      it 'vote up' do
        expect { post :vote_up, params: { id: votable, format: :json } }.not_to change(votable.votes, :count)
      end
    end

    context 'Unauthenticated user' do
      it 'vote up' do
        expect { post :vote_up, params: { id: votable, format: :json } }.not_to change(votable.votes, :count)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'User' do
      before { login(user) }

      it 'vote down' do
        expect { post :vote_down, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(1)
      end
    end

    context 'Author' do
      before { login(author) }

      it 'vote down' do
        expect { post :vote_down, params: { id: votable, format: :json } }.not_to change(votable.votes, :count)
      end
    end

    context 'Unauthenticated user' do
      it 'vote down' do
        expect { post :vote_down, params: { id: votable, format: :json } }.not_to change(votable.votes, :count)
      end
    end
  end
end
