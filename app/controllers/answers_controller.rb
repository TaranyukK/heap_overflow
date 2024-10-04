class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[update destroy mark_as_best]
  before_action :set_question_from_answer, only: %i[update destroy mark_as_best]

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

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
