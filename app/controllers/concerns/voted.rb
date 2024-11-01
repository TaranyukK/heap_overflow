module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down]
  end

  def vote_up
    @votable.vote_up(current_user)

    render_json
  end

  def vote_down
    @votable.vote_down(current_user)

    render_json
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def render_json
    render json: { resource_class: model_klass.to_s, id: @votable.id, rating: @votable.rating }
  end
end
