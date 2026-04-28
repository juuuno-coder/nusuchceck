class ServiceZone < ApplicationRecord
  has_many :zone_claims, dependent: :destroy
  has_many :masters, through: :zone_claims

  scope :active, -> { where(active: true) }
  scope :by_region, ->(region) { where(region: region) }
  scope :available, -> { active.where("claimed_slots_count < max_slots") }

  validates :name, presence: true
  validates :region, presence: true
  validates :max_slots, numericality: { greater_than: 0 }
  validates :name, uniqueness: { scope: :region }

  def full?
    claimed_slots_count >= max_slots
  end

  def available_slots
    max_slots - claimed_slots_count
  end

  def districts_text
    districts.is_a?(Array) ? districts.join(", ") : ""
  end

  def display_name
    "#{region} #{name}"
  end

  def population_range_text
    return "미정" if population.to_i.zero?
    man = population / 10000
    lower = (man * 0.8 / 5).round * 5
    upper = (man * 1.2 / 5).round * 5
    lower = [lower, 5].max
    "약 #{lower}만~#{upper}만명"
  end

  # 인구 기반 슬롯 계산 (8~10만 당 1개, 최소 2, 최대 10)
  def calculated_max_slots
    return 2 if population.to_i.zero?
    [[population / 90000, 2].max, 10].min
  end

  # 인구 기반으로 슬롯 자동 설정
  def sync_slots_from_population!
    update_column(:max_slots, calculated_max_slots)
  end
end
