class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, dependent: :destroy

  has_one_attached :file

  validates :title, :body, presence: true

  def best_answer
    answers.best.first
  end
end
