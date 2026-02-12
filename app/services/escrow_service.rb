class EscrowService
  class EscrowError < StandardError; end

  attr_reader :request

  def initialize(request)
    @request = request
  end

  # 에스크로 생성 및 입금 처리
  def create_and_deposit!(amount:, payment_method: "card")
    ActiveRecord::Base.transaction do
      escrow = request.escrow_transaction || request.build_escrow_transaction(
        customer: request.customer,
        master: request.master,
        amount: amount,
        payment_method: payment_method
      )

      escrow.save!

      # PG사 결제 처리 (MVP에서는 시뮬레이션)
      pg_result = simulate_pg_payment(escrow)
      escrow.update!(pg_transaction_id: pg_result[:transaction_id])
      escrow.deposit!

      escrow
    end
  rescue AASM::InvalidTransition => e
    raise EscrowError, "에스크로 입금 상태 전환 실패: #{e.message}"
  end

  # 대금 지급 (마스터에게)
  def release!
    escrow = request.escrow_transaction
    raise EscrowError, "에스크로 거래가 없습니다." unless escrow

    ActiveRecord::Base.transaction do
      escrow.release!

      # PG사 정산 처리 (MVP에서는 시뮬레이션)
      simulate_pg_settlement(escrow)

      escrow.settle!
    end
  rescue AASM::InvalidTransition => e
    raise EscrowError, "대금 지급 상태 전환 실패: #{e.message}"
  end

  # 환불 처리
  def refund!
    escrow = request.escrow_transaction
    raise EscrowError, "에스크로 거래가 없습니다." unless escrow

    ActiveRecord::Base.transaction do
      # PG사 환불 처리 (MVP에서는 시뮬레이션)
      simulate_pg_refund(escrow)

      escrow.refund!
    end
  rescue AASM::InvalidTransition => e
    raise EscrowError, "환불 상태 전환 실패: #{e.message}"
  end

  private

  # MVP: PG사 결제 시뮬레이션
  def simulate_pg_payment(escrow)
    {
      success: true,
      transaction_id: "PG_#{SecureRandom.hex(10)}",
      amount: escrow.amount
    }
  end

  # MVP: PG사 정산 시뮬레이션
  def simulate_pg_settlement(escrow)
    Rails.logger.info "[EscrowService] 정산 시뮬레이션: 마스터 #{escrow.master_id}에게 #{escrow.master_payout}원 정산"
    true
  end

  # MVP: PG사 환불 시뮬레이션
  def simulate_pg_refund(escrow)
    Rails.logger.info "[EscrowService] 환불 시뮬레이션: 고객 #{escrow.customer_id}에게 #{escrow.amount}원 환불"
    true
  end
end
