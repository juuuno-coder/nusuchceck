class Feedback < ApplicationRecord
  CATEGORIES = %w[기능제안 버그신고 일반문의 기타].freeze

  belongs_to :user, optional: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true
  validates :message, presence: true, length: { minimum: 10 }

  before_validation :set_defaults

  private

  def set_defaults
    self.category ||= '일반문의'
    self.name ||= user&.name || '익명'
  end

  enum status: {
    pending: 'pending',
    reviewed: 'reviewed',
    resolved: 'resolved'
  }, _prefix: true

  scope :recent, -> { order(created_at: :desc) }
  scope :unreviewed, -> { where(status: 'pending') }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email category status created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
