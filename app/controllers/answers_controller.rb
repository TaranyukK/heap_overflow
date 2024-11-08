class AnswersController < ApplicationController
  include Voted

  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy mark_as_best]
  before_action :set_question_from_answer, only: %i[update destroy mark_as_best]
  before_action :set_new_comment
  after_action :publish_answer, only: %i[create]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def mark_as_best
    @answer.mark_as_best
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def set_question_from_answer
    @question = @answer.question
  end

  def set_new_comment
    @comment = Comment.new(commentable: @answer)
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("questions/#{@answer.question.id}", @answer)
  end
end
