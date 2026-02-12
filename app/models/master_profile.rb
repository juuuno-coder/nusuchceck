class MasterProfile < ApplicationRecord
  belongs_to :user, class_name: "Master", inverse_of: :master_profile

  validates :user_id, uniqueness: true
  validates :license_number, presence: true, if: :verified?
  validates :bank_name, :account_number, :account_holder, presence: true, if: :verified?
  validates :experience_years, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :verified, -> { where(verified: true) }
  scope :unverified, -> { where(verified: false) }

  def verify!
    update!(verified: true, verified_at: Time.current)
  end

  def reject!
    update!(verified: false, verified_at: nil)
  end

  def equipment_list
    equipment.is_a?(Array) ? equipment : []
  end

  def service_areas_list
    service_areas.is_a?(Array) ? service_areas : []
  end
end
