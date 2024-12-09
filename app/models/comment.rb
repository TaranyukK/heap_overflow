class Comment < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search,
                  against: :body,
                  using:   {
                    tsearch: { prefix: true }
                  }

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true
end
