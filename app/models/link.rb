class Link < ApplicationRecord
  GIST_URL_REGEX = %r{https*://gist.github.com/\w+}

  belongs_to :linkable, polymorphic: true

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  validates :name, presence: true

  def gist_url?
    GIST_URL_REGEX.match?(url)
  end
end
