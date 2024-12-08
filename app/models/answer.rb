class Answer < ApplicationRecord
  include PgSearch::Model
  include Linkable
  include Votable
  include Commentable

  pg_search_scope :search,
                  against: :body,
                  using:   {
                    tsearch: { prefix: true }
                  }

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }
  scope :best, -> { where(best: true) }

  def mark_as_best
    Answer.transaction do
      question.best_answer&.update!(best: false)
      update!(best: true)
      question.give_award!(user)
    end
  end
end
