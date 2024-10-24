class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new(question: @question)
    @answer.links.build
  end

  def new
    @question = current_user.questions.build
    @question.links.build
    @question.build_award
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files:            [],
                                     links_attributes: %i[id name url _destroy],
                                     award_attributes: %i[title image])
  end
end
