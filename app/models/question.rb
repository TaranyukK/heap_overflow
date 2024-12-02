class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_one :award, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :subscribe_author

  def best_answer
    answers.best.first
  end

  def give_award!(user)
    user.awards << award if award
  end

  private

  def subscribe_author
    subscriptions.create!(user: user)
  end
end
