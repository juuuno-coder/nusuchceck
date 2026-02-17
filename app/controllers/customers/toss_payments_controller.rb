class Customers::TossPaymentsController < ApplicationController
  include CustomerAccessible

  before_action :set_request

  ESCROW_TYPE_LABELS = {
    "trip"         => "누수체크 출장비",
    "detection"    => "누수체크 탐지비",
    "construction" => "누수체크 공사비"
  }.freeze

  # GET /customers/toss_payments/checkout
  # params: request_id, escrow_type, amount
  def checkout
    @escrow_type = params[:escrow_type]
    @amount      = params[:amount].to_d.round

    unless ESCROW_TYPE_LABELS.key?(@escrow_type)
      redirect_to customers_request_path(@request), alert: "잘못된 결제 유형입니다."
      return
    end

    unless @amount > 0
      redirect_to customers_request_path(@request), alert: "결제 금액이 올바르지 않습니다."
      return
    end

    @order_id   = "NUSU-#{@request.id}-#{@escrow_type}-#{SecureRandom.hex(6)}"
    @order_name = ESCROW_TYPE_LABELS[@escrow_type]
    @toss_client_key = ENV.fetch("TOSS_CLIENT_KEY", "test_ck_placeholder")

    @success_url = customers_toss_payments_success_url(
      request_id:  @request.id,
      escrow_type: @escrow_type,
      order_id:    @order_id
    )
    @fail_url = customers_toss_payments_fail_url(
      request_id:  @request.id,
      escrow_type: @escrow_type
    )
  end

  # GET /customers/toss_payments/success
  # params: paymentKey, orderId, amount, request_id, escrow_type
  def success
    payment_key  = params[:paymentKey]
    order_id     = params[:orderId]
    amount       = params[:amount].to_d
    escrow_type  = params[:escrow_type]

    unless payment_key.present? && order_id.present? && amount > 0
      redirect_to customers_request_path(@request), alert: "결제 정보가 올바르지 않습니다."
      return
    end

    # 토스 API로 결제 승인
    toss_result = TossPaymentsService.new.confirm_payment(
      payment_key: payment_key,
      order_id:    order_id,
      amount:      amount
    )

    # EscrowService로 DB 업데이트
    EscrowService.new(@request).finalize_payment!(
      escrow_type:    escrow_type,
      amount:         amount,
      payment_key:    payment_key,
      order_id:       order_id,
      payment_method: normalize_payment_method(toss_result["method"])
    )

    label = ESCROW_TYPE_LABELS[escrow_type] || "결제"
    redirect_to customers_request_path(@request),
      notice: "#{label} #{number_to_currency(amount, unit: '₩', precision: 0)} 결제가 완료되었습니다."

  rescue TossPaymentsService::PaymentError => e
    Rails.logger.error "[TossPayments] 결제 승인 실패: #{e.message} | order_id=#{params[:orderId]}"
    redirect_to customers_request_path(@request),
      alert: "결제 승인 중 오류가 발생했습니다: #{e.message}"
  rescue EscrowService::EscrowError => e
    Rails.logger.error "[TossPayments] 에스크로 처리 실패: #{e.message} | order_id=#{params[:orderId]}"
    redirect_to customers_request_path(@request),
      alert: "결제는 완료되었으나 처리 중 오류가 발생했습니다. 고객센터에 문의해주세요."
  end

  # GET /customers/toss_payments/fail
  # params: code, message, request_id, escrow_type
  def fail
    error_message = params[:message] || "알 수 없는 오류"
    error_code    = params[:code]
    Rails.logger.warn "[TossPayments] 결제 실패: code=#{error_code} message=#{error_message}"

    redirect_to customers_request_path(@request),
      alert: "결제가 취소되었습니다. (#{error_message})"
  end

  private

  def set_request
    @request = current_user.requests.find(params[:request_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to customers_requests_path, alert: "체크 정보를 찾을 수 없습니다."
  end

  def normalize_payment_method(toss_method)
    case toss_method
    when "카드"          then "card"
    when "가상계좌"       then "virtual_account"
    when "간편결제"       then "easy_pay"
    when "휴대폰"        then "mobile"
    when "계좌이체"       then "bank_transfer"
    else toss_method || "card"
    end
  end
end
