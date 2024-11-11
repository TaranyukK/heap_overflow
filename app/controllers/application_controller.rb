class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_commentable

  private

  def set_commentable
    gon.commentable = {Question: [], Answer: []} unless gon.commentable
  end
end
