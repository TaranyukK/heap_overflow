class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create]
  before_action :set_comment, only: %i[update destroy]
  after_action :publish_comment, only: %i[create]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def update
    @comment.update(comment_params)
  end

  def destroy
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = if params[:question_id]
                     Question.find(params[:question_id])
                   elsif params[:answer_id]
                     Answer.find(params[:answer_id])
                   end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments_for_#{@commentable.class.name}_#{@commentable.id}", @comment.to_json)
  end
end
