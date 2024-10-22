class Link < ApplicationRecord
  VALID_URL_REGEX = /\Ahttps?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)\z/i
  GIST_URL_REGEX = /https*:\/\/gist.github.com\/\w+/

  belongs_to :linkable, polymorphic: true

  validates :url, presence: true, format: { with: VALID_URL_REGEX }
  validates :name, presence: true

  def gist_url?
    GIST_URL_REGEX.match?(url)
  end
end
