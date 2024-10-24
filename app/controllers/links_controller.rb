class LinksController < ApplicationController
  before_action :set_link, only: :destroy

  def destroy
    @link.destroy
  end

  private

  def set_link
    @link = Link.find(params[:id])
  end
end
