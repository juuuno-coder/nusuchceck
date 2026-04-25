class Notification < ApplicationRecord
  # Associations
  belongs_to :recipient, polymorphic: true
  belongs_to :actor, polymorphic: true, optional: true
  belongs_to :notifiable, polymorphic: true, optional: true

  # Scopes
  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  # Methods
  def read?
    read_at.present?
  end

  def unread?
    !read?
  end

  def mark_as_read!
    update(read_at: Time.current) unless read?
  end

  def mark_as_unread!
    update(read_at: nil) if read?
  end

  # 알림 타입별 아이콘 (SVG class용)
  def icon
    case action
    when "request_assigned"      then "wrench"
    when "estimate_submitted"    then "currency"
    when "estimate_accepted"     then "check"
    when "construction_completed" then "flag"
    when "insurance_review_requested" then "document"
    when "insurance_approved"    then "check"
    when "insurance_change_requested" then "pencil"
    when "payment_released"      then "banknotes"
    else "bell"
    end
  end

  # 알림 타입별 색상
  def badge_color
    case action
    when "estimate_submitted", "insurance_review_requested"
      "bg-blue-100 text-blue-800"
    when "estimate_accepted", "insurance_approved", "construction_completed"
      "bg-green-100 text-green-800"
    when "insurance_change_requested"
      "bg-yellow-100 text-yellow-800"
    when "payment_released"
      "bg-purple-100 text-purple-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end
end
