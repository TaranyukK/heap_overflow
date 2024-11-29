class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :rating, :best, :body, :user_id, :created_at, :updated_at

  has_many :links
  has_many :files
  has_many :comments
  belongs_to :user
end
