class Estimate < ApplicationRecord
  belongs_to :request
  belongs_to :master, class_name: "Master", inverse_of: :estimates

  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :request_id, presence: true
  validates :master_id, presence: true

  scope :pending, -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }
  scope :recent, -> { order(created_at: :desc) }

  before_save :calculate_totals

  def accept!
    update!(status: "accepted", accepted_at: Time.current)
  end

  def reject!
    update!(status: "rejected")
  end

  def expire!
    update!(status: "expired")
  end

  def pending?
    status == "pending"
  end

  def accepted?
    status == "accepted"
  end

  def rejected?
    status == "rejected"
  end

  def expired?
    status == "expired"
  end

  def parsed_line_items
    return [] unless line_items.is_a?(Array)
    line_items.map { |item| item.with_indifferent_access }
  end

  def status_label
    case status
    when "pending" then "검토 대기"
    when "accepted" then "수락됨"
    when "rejected" then "거절됨"
    when "expired" then "만료됨"
    else status
    end
  end

  private

  def calculate_totals
    items = parsed_line_items
    self.detection_subtotal = items.select { |i| i[:category] == "detection" }.sum { |i| i[:amount].to_d }
    self.construction_subtotal = items.select { |i| i[:category] == "construction" }.sum { |i| i[:amount].to_d }
    self.material_subtotal = items.select { |i| i[:category] == "material" }.sum { |i| i[:amount].to_d }
    subtotal = detection_subtotal + construction_subtotal + material_subtotal +
               items.select { |i| i[:category] == "trip" }.sum { |i| i[:amount].to_d }
    self.vat = (subtotal * 0.1).round(2)
    self.total_amount = subtotal + vat
  end
end
