class Award < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :image

  validates :title, presence: true

  validate :validate_image

  private

  def validate_image
    errors.add(:image, 'must be attached') unless image.attached?

    return unless image.attached? && !image.content_type.in?(%w[image/png image/jpg image/jpeg])

    errors.add(:image, 'must be a PNG, JPG or JPEG')
  end
end
