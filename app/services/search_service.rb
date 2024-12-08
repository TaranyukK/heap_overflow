class SearchService
  def initialize(query, model)
    @query = query
    @model = model
  end

  def call
    return { @model => @model.constantize.search(@query) } if @model.present?

    questions = Question.search(@query)
    answers = Answer.search(@query)
    comments = Comment.search(@query)
    users = User.search(@query)

    { questions: questions, answers: answers, comments: comments, users: users }
  end
end
