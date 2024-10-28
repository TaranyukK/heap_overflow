class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :positive, presence: true

  scope :positive, -> { where(positive: true) }
  scope :negative, -> { where(positive: false) }
end
