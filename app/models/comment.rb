class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  belongs_to :parent, class_name: "Comment", optional: true, foreign_key: :parent_id
  has_many   :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  validates :content, presence: true, length: { maximum: 1000 }

  scope :roots, -> { where(parent_id: nil) }
  scope :recent, -> { order(created_at: :asc) }
end
