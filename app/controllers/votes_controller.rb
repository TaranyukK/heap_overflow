class VotesController < ApplicationController
  before_action :set_vote

  def vote_up
    @votable.vote(1)
    render_json
  end

  def vote_down
    @votable.vote(-1)
    render_json
  end

  private

  def set_votable
    @votable = controller_name.classify.constantize.find(params[:id])
  end

  def render_json
    render json: { id: @votable.id, rating: @votable.rating }
  end
end
