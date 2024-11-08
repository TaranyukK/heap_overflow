class VotesController < ApplicationController
  before_action :set_votable

  def vote_up
    @votable.vote(1)

    render json: { id: @votable.id, rating: @votable.rating }
  end

  def vote_down
    @votable.vote(-1)

    render json: { id: @votable.id, rating: @votable.rating }
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end
end
