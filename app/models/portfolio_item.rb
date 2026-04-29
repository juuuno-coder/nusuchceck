class PortfolioItem < ApplicationRecord
  belongs_to :master_profile
  has_one_attached :image

  scope :ordered, -> { order(pinned: :desc, position: :asc, created_at: :desc) }
  scope :pinned, -> { where(pinned: true) }

  validates :master_profile_id, presence: true

  def display_image_url
    if image.attached?
      Rails.application.routes.url_helpers.url_for(image.variant(resize_to_fill: [400, 400]))
    elsif image_url.present?
      image_url
    end
  end

  def has_image?
    image.attached? || image_url.present?
  end

  def from_instagram?
    source == "instagram"
  end
end
