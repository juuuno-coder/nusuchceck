# 결제 이력 감사 추적 모델
# 모든 결제 시도를 기록하여 분쟁 시 추적 가능
class PaymentAuditLog < ApplicationRecord
  belongs_to :escrow_transaction, optional: true  # 결제 시도 단계에서는 없을 수 있음
  belongs_to :user, optional: true  # 결제 시도한 사용자

  # action: attempt, success, fail, refund, cancel, webhook_received
  validates :action, presence: true, inclusion: {
    in: %w[attempt success fail refund cancel webhook_received],
    message: "%{value} is not a valid action"
  }

  # details: JSON (request params, response data, error message 등)
  # ip_address: 결제 시도한 IP 주소

  scope :recent, -> { order(created_at: :desc) }
  scope :by_action, ->(action) { where(action: action) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :successful, -> { where(action: "success") }
  scope :failed, -> { where(action: "fail") }

  # 결제 시도 기록
  # @param escrow_transaction [EscrowTransaction, nil]
  # @param user [User, nil]
  # @param action [String] attempt, success, fail, refund, cancel, webhook_received
  # @param details [Hash] 상세 정보 (request params, response, error 등)
  # @param ip_address [String, nil] IP 주소
  def self.log_payment(escrow_transaction: nil, user: nil, action:, details: {}, ip_address: nil)
    create!(
      escrow_transaction: escrow_transaction,
      user: user,
      action: action,
      details: details,
      ip_address: ip_address
    )
  rescue => e
    Rails.logger.error "[PaymentAuditLog] 감사 로그 기록 실패: #{e.message}"
    # 감사 로그 실패가 결제를 막아서는 안 됨
    nil
  end

  # 결제 성공률 계산
  # @return [Float] 성공률 (0~100)
  def self.success_rate(period: 30.days.ago..Time.current)
    total = where(created_at: period, action: %w[success fail]).count
    return 0.0 if total.zero?

    successful_count = where(created_at: period, action: "success").count
    (successful_count.to_f / total * 100).round(2)
  end
end
