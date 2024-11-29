class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :rating, :title, :short_title, :body, :user_id, :created_at, :updated_at

  has_many :links
  has_many :files
  has_many :comments
  has_many :answers
  belongs_to :user

  def short_title
    object.title.truncate(7)
  end
end
