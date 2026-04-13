class Subscription < ApplicationRecord
  belongs_to :master, class_name: "Master"

  enum tier: {
    free: 0,       # 무료: 월 5건 제한, 일반 매칭
    basic: 1,      # 베이직: 월 20,000원, 월 무제한, 일반 매칭
    premium: 2,    # 프리미엄: 월 50,000원, 월 무제한, 우선 매칭, 프로필 상단 노출
    zone: 3        # 마스터 플랜: 월 99,000원, 1구역 우선 노출, 자동결제(빌링키)
  }

  validates :tier, presence: true
  validates :monthly_fee, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true).where("expires_on > ?", Date.current) }
  scope :premium, -> { where(tier: :premium) }
  scope :basic_or_premium, -> { where(tier: [:basic, :premium]) }
  scope :paid, -> { where(tier: [:basic, :premium, :zone]) }
  scope :with_billing, -> { where.not(billing_key: nil) }

  # 티어별 특징 반환
  def features_for_tier
    case tier
    when "free"
      {
        monthly_limit: 5,
        priority_matching: false,
        profile_boost: false,
        ad_free: false,
        display_name: "무료 플랜",
        description: "누수체크를 시작해보세요"
      }
    when "basic"
      {
        monthly_limit: nil,  # 무제한
        priority_matching: false,
        profile_boost: false,
        ad_free: true,
        display_name: "베이직 플랜",
        description: "무제한으로 고객을 만나보세요"
      }
    when "premium"
      {
        monthly_limit: nil,
        priority_matching: true,
        profile_boost: true,
        ad_free: true,
        zone_claim: false,
        display_name: "프리미엄 플랜",
        description: "우선 매칭으로 더 많은 기회를"
      }
    when "zone"
      {
        monthly_limit: nil,
        priority_matching: true,
        profile_boost: true,
        ad_free: true,
        zone_claim: true,           # 구역 우선 노출 슬롯 1개
        auto_billing: true,          # 자동결제 (빌링키)
        display_name: "전문가 등록 마스터 플랜",
        description: "내 구역 1위 전문가로 우선 노출"
      }
    end
  end

  # 구독 갱신
  def renew!(months: 1)
    update!(
      starts_on: Date.current,
      expires_on: Date.current + months.months
    )
  end

  # 구독 활성화 여부
  def active?
    super && expires_on > Date.current
  end

  # 이번 달 클레임 가능 건수 확인
  def can_claim_request?
    return true if basic? || premium? || zone?
    return true if free? && monthly_claimed_count < 5
    false
  end

  # 이번 달 클레임한 건수
  def monthly_claimed_count
    return 0 unless master
    master.assigned_requests.where("created_at >= ?", 1.month.ago).count
  end

  # 남은 클레임 가능 건수
  def remaining_claims
    return Float::INFINITY if basic? || premium? || zone?
    [5 - monthly_claimed_count, 0].max
  end

  # 월 구독료 설정
  def set_monthly_fee_by_tier!
    self.monthly_fee = case tier
    when "free" then 0
    when "basic" then 20_000
    when "premium" then 50_000
    when "zone" then 99_000
    else 0
    end
  end

  # 빌링키로 자동결제 가능 여부
  def has_billing_key?
    billing_key.present?
  end

  # 구독 만료 임박 (7일 이내)
  def expiring_soon?
    expires_on.present? && expires_on <= 7.days.from_now.to_date
  end

  # 자동결제로 구독 갱신
  def activate_with_billing!(billing_key:, customer_key:)
    update!(
      billing_key: billing_key,
      customer_key: customer_key,
      billing_status: "active",
      tier: :zone,
      monthly_fee: 99_000,
      starts_on: Date.current,
      expires_on: Date.current + 1.month,
      active: true,
      next_billing_at: Date.current + 1.month
    )
  end
end
