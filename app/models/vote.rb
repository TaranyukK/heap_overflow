class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true

  scope :positive, -> { where(value: 1).length }
  scope :negative, -> { where(value: -1).length }
end
