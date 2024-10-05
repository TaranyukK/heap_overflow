class Answer < ApplicationRecord
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
    end
  end
end
