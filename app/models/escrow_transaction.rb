class EscrowTransaction < ApplicationRecord
  include AASM

  belongs_to :request
  belongs_to :customer, class_name: "Customer", inverse_of: :escrow_transactions
  belongs_to :master, class_name: "Master", inverse_of: :escrow_transactions

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :request_id, uniqueness: true

  PLATFORM_FEE_RATE = ENV.fetch("PLATFORM_FEE_RATE", "0.15").to_f

  before_save :calculate_fees

  aasm column: :status, whiny_transitions: true do
    state :pending, initial: true
    state :deposited
    state :held
    state :released
    state :settled
    state :refunded
    state :disputed

    # 입금
    event :deposit do
      before { self.deposited_at = Time.current }
      transitions from: :pending, to: :deposited
    end

    # 보류 (분쟁 등)
    event :hold do
      transitions from: :deposited, to: :held
    end

    # 대금 지급
    event :release do
      before { self.released_at = Time.current }
      transitions from: [:deposited, :held], to: :released
    end

    # 정산 완료
    event :settle do
      transitions from: :released, to: :settled
    end

    # 환불
    event :refund do
      before { self.refunded_at = Time.current }
      transitions from: [:pending, :deposited, :held], to: :refunded
    end

    # 분쟁
    event :dispute do
      transitions from: [:deposited, :held], to: :disputed
    end
  end

  def fee_amount
    (amount * PLATFORM_FEE_RATE).round(2)
  end

  def payout_amount
    (amount - fee_amount).round(2)
  end

  def status_label
    case status
    when "pending" then "입금 대기"
    when "deposited" then "입금 완료"
    when "held" then "보류 중"
    when "released" then "지급 완료"
    when "settled" then "정산 완료"
    when "refunded" then "환불 완료"
    when "disputed" then "분쟁 중"
    else status
    end
  end

  private

  def calculate_fees
    self.platform_fee = fee_amount
    self.master_payout = payout_amount
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id status amount customer_id master_id request_id created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[customer master request]
  end
end
