class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create update destroy]
  before_action :set_answer, only: %i[update destroy]

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
