class SearchService
  SEARCH_MODELS = [Question, Answer, Comment, User].freeze

  def initialize(query, model)
    @query = query
    @model = model
    @results = []
  end

  def call
    return if @query.blank?
    return @model.constantize.search(@query) if @model.present?

    SEARCH_MODELS.map do |model|
      model.search(@query)
    end.flatten
  end
end
