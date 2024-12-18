class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answer, only: %i[show update destroy]
  before_action :set_question, only: %i[index create]

  authorize_resource

  def index
    render json: @question.answers
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      render json: @answer, status: :created
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer, status: :ok
    else
      render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    render json: { message: 'Answer deleted' }, status: :ok
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
