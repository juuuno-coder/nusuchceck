class PgWebhooksController < ApplicationController
  # 웹훅은 CSRF 토큰 없이 호출됨
  skip_before_action :verify_authenticity_token
  # Devise 인증 우회
  skip_before_action :authenticate_user!, raise: false

  # POST /pg/webhooks/toss
  def toss
    payload = JSON.parse(request.body.read)
    Rails.logger.info "[Toss Webhook] 수신: #{payload['eventType']}"

    event_type = payload["eventType"]
    data       = payload["data"]

    case event_type
    when "PAYMENT_STATUS_CHANGED"
      handle_payment_status_changed(data)
    end

    head :ok
  rescue JSON::ParserError => e
    Rails.logger.error "[Toss Webhook] JSON 파싱 오류: #{e.message}"
    head :bad_request
  rescue => e
    Rails.logger.error "[Toss Webhook] 처리 오류: #{e.message}"
    head :ok  # 토스는 200이 아니면 재시도하므로 항상 200 응답
  end

  private

  def handle_payment_status_changed(data)
    return unless data

    order_id    = data["orderId"]
    status      = data["status"]
    payment_key = data["paymentKey"]

    return unless order_id.present?

    escrow = EscrowTransaction.find_by(toss_order_id: order_id)
    return unless escrow

    case status
    when "DONE"
      # 성공 콜백(success action)에서 이미 처리했으므로 중복 처리 방지
      Rails.logger.info "[Toss Webhook] DONE (이미 처리됨): #{order_id}"
    when "CANCELED", "PARTIAL_CANCELED"
      # 결제 취소 → 에스크로 환불 처리
      ActiveRecord::Base.transaction do
        escrow.refund! if escrow.may_refund?
      end
      Rails.logger.info "[Toss Webhook] 취소 처리 완료: #{order_id}"
    when "ABORTED"
      Rails.logger.warn "[Toss Webhook] 결제 중단: #{order_id}"
    end
  end
end
