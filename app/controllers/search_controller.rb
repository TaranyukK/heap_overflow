class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def index
    @query = params[:query]
    @model = params[:model]
    @results = {}

    return if @query.blank?

    @results = SearchService.new(@query, @model).call
  end
end
