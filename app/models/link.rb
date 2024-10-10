class Link < ApplicationRecord
  VALID_URL_REGEX = /\A(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\z/i

  belongs_to :linkable, polymorphic: true

  validates :url, presence: true, format: { with: VALID_URL_REGEX }
  validates :name, presence: true
end
