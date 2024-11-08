class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments_#{params[:commentable_type]}_#{params[:commentable_id]}"
  end
end
