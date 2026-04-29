class MasterProfile < ApplicationRecord
  SPECIALTY_OPTIONS = %w[수도배관 방수 욕실 옥상 바닥 외벽].freeze

  belongs_to :user, class_name: "Master", inverse_of: :master_profile
  has_many :portfolio_items, dependent: :destroy

  before_create :generate_public_token

  validates :user_id, uniqueness: true
  validates :license_number, presence: true, if: :verified?
  validates :bank_name, :account_number, :account_holder, presence: true, if: :verified?
  validates :experience_years, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :verified, -> { where(verified: true) }
  scope :unverified, -> { where(verified: false) }
  scope :insurance_verified, -> { where(insurance_verified: true).where("insurance_valid_until IS NULL OR insurance_valid_until >= ?", Date.current) }
  scope :insurance_pending, -> { where(insurance_pending_review: true) }

  has_one_attached :insurance_certificate
  has_one_attached :profile_photo
  has_many_attached :work_photos

  PROFILE_REVIEW_STATUSES = %w[pending approved flagged].freeze
  AVAILABILITY_STATUSES = %w[available away busy].freeze

  enum :availability, { available: "available", away: "away", busy: "busy" }, prefix: true

  def available_for_assignment?
    availability_available? && (!away_until || away_until < Date.current)
  end

  def insurance_active?
    insurance_verified? && (insurance_valid_until.nil? || insurance_valid_until >= Date.current)
  end

  def insurance_expiring_soon?
    insurance_active? && insurance_valid_until.present? && insurance_valid_until <= 30.days.from_now
  end

  def approve_insurance!(ocr_data = {})
    update!(
      insurance_verified: true,
      insurance_verified_at: Time.current,
      insurance_pending_review: false,
      insurance_insurer_name: ocr_data[:insurer_name],
      insurance_valid_until: ocr_data[:valid_until]
    )
  end

  def reject_insurance!
    update!(
      insurance_verified: false,
      insurance_pending_review: false,
      insurance_ocr_data: {}
    )
  end

  def verify!
    update_columns(verified: true, verified_at: Time.current)
  end

  def reject!
    update_columns(verified: false, verified_at: nil)
  end

  def equipment_list
    equipment.is_a?(Array) ? equipment : []
  end

  def service_areas_list
    service_areas.is_a?(Array) ? service_areas : []
  end

  def specialty_types_list
    specialty_types.is_a?(Array) ? specialty_types : []
  end

  def certifications_list
    certifications.is_a?(Array) ? certifications : []
  end

  def profile_approved?
    profile_review_status == "approved"
  end

  def profile_flagged?
    profile_review_status == "flagged"
  end

  # 커스텀 링크 헬퍼
  def parsed_links
    (custom_links.is_a?(Array) ? custom_links : []).map(&:symbolize_keys)
  end

  # SNS 타입 자동 감지
  def self.detect_link_type(url)
    case url.to_s.downcase
    when /instagram\.com/ then "instagram"
    when /youtube\.com|youtu\.be/ then "youtube"
    when /blog\.naver\.com/ then "naver_blog"
    when /tiktok\.com/ then "tiktok"
    when /facebook\.com/ then "facebook"
    when /twitter\.com|x\.com/ then "twitter"
    when /kakao/ then "kakao"
    else "website"
    end
  end

  private

  def generate_public_token
    loop do
      self.public_token = SecureRandom.alphanumeric(10).downcase
      break unless MasterProfile.exists?(public_token: public_token)
    end
  end
end
