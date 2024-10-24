class AttachmentsController < ApplicationController
  before_action :set_attachment, only: :destroy

  def destroy
    @attachment.purge
  end

  private

  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end
