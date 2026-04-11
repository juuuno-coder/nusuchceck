class ZoneClaim < ApplicationRecord
  belongs_to :master, class_name: "User"
  belongs_to :service_zone

  validates :master_id, uniqueness: { scope: :service_zone_id, message: "이미 선점한 구역이에요" }
  validate :zone_not_full, on: :create

  scope :active, -> { where(status: "active") }
  scope :expired, -> { where(status: "expired") }

  before_create :set_claimed_at
  after_save :update_slot_count
  after_destroy :update_slot_count

  def active?
    status == "active"
  end

  def release!
    update!(status: "released", released_at: Time.current)
  end

  def expire!
    update!(status: "expired")
  end

  private

  def zone_not_full
    return unless service_zone
    if service_zone.full? && status == "active"
      errors.add(:base, "이 구역은 모든 슬롯이 선점됐어요")
    end
  end

  def set_claimed_at
    self.claimed_at ||= Time.current
    self.expires_at ||= 1.year.from_now
  end

  def update_slot_count
    service_zone.update_column(:claimed_slots_count, service_zone.zone_claims.active.count)
  end
end
