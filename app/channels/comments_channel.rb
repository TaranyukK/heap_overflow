class CommentsChannel < ApplicationCable::Channel
  def follow
    params[:commentable].each do |k, v|
      v.each do |id|
        stream_from "comments_for_#{k}_#{id}"
      end
    end
  end
end
