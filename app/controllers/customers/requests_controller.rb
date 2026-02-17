class Customers::RequestsController < ApplicationController
  include CustomerAccessible

  before_action :set_request, only: [
    :show, :cancel, :accept_estimate,
    :deposit_trip_fee, :deposit_detection_fee, :deposit_escrow,
    :confirm_completion, :submit_complaint
  ]

  def index
    @q = current_user.requests.ransack(params[:q])
    @requests = @q.result.recent.page(params[:page])
  end

  def show
    authorize @request
  end

  def new
    @request = current_user.requests.build
  end

  def create
    @request = current_user.requests.build(request_params)

    if @request.save
      redirect_to customers_request_path(@request), notice: "누수 신고가 접수되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    authorize @request
    if @request.may_cancel?
      @request.cancel!
      redirect_to customers_request_path(@request), notice: "신고가 취소되었습니다."
    else
      redirect_to customers_request_path(@request), alert: "현재 상태에서는 취소할 수 없습니다."
    end
  end

  def accept_estimate
    authorize @request
    estimate = @request.estimates.find(params[:estimate_id])
    ActiveRecord::Base.transaction do
      estimate.accept!
      @request.accept_estimate!
    end
    redirect_to customers_request_path(@request), notice: "견적을 수락했습니다."
  rescue => e
    redirect_to customers_request_path(@request), alert: "견적 수락에 실패했습니다: #{e.message}"
  end

  # ─── 1단계: 출장비 에스크로 ───────────────────────────────────
  def deposit_trip_fee
    authorize @request, :deposit_escrow?
    amount = params[:amount]&.to_d || @request.trip_fee.to_d
    unless amount > 0
      redirect_to customers_request_path(@request), alert: "출장비 금액이 없습니다."
      return
    end

    escrow = EscrowService.new(@request).create_trip_escrow!(
      amount: amount,
      payment_method: params[:payment_method] || "card"
    )
    redirect_to customers_request_path(@request), notice: "출장비 #{number_to_currency(escrow.amount, unit: "₩", precision: 0)} 입금 완료"
  rescue => e
    redirect_to customers_request_path(@request), alert: "출장비 결제 오류: #{e.message}"
  end

  # ─── 2단계: 검사비 에스크로 ───────────────────────────────────
  def deposit_detection_fee
    authorize @request, :deposit_escrow?
    amount = params[:amount]&.to_d || @request.detection_fee.to_d
    unless amount > 0
      redirect_to customers_request_path(@request), alert: "검사비 금액이 없습니다."
      return
    end

    escrow = EscrowService.new(@request).create_detection_escrow!(
      amount: amount,
      payment_method: params[:payment_method] || "card"
    )
    redirect_to customers_request_path(@request), notice: "검사비 #{number_to_currency(escrow.amount, unit: "₩", precision: 0)} 입금 완료"
  rescue => e
    redirect_to customers_request_path(@request), alert: "검사비 결제 오류: #{e.message}"
  end

  # ─── 3단계: 공사비 에스크로 (기존) ───────────────────────────
  def deposit_escrow
    authorize @request
    estimate = @request.accepted_estimate
    unless estimate
      redirect_to customers_request_path(@request), alert: "수락된 견적이 없습니다."
      return
    end

    escrow = EscrowService.new(@request).create_construction_escrow!(
      amount: estimate.total_amount,
      payment_method: params[:payment_method] || "card"
    )

    if escrow.deposited?
      @request.deposit_escrow!
      redirect_to customers_request_path(@request), notice: "공사비 에스크로 입금이 완료되었습니다."
    else
      redirect_to customers_request_path(@request), alert: "에스크로 입금에 실패했습니다."
    end
  rescue => e
    redirect_to customers_request_path(@request), alert: "결제 처리 중 오류: #{e.message}"
  end

  def confirm_completion
    authorize @request
    if @request.may_confirm_completion?
      @request.confirm_completion!
      redirect_to customers_request_path(@request), notice: "공사 완료가 확인되었습니다. 감사합니다!"
    else
      redirect_to customers_request_path(@request), alert: "현재 상태에서는 완료 확인을 할 수 없습니다."
    end
  end

  # ─── 고객 불만 제출 (완료 후 하자보수 요청) ──────────────────
  def submit_complaint
    authorize @request, :show?
    complaint_text = params[:complaint].presence
    unless complaint_text
      redirect_to customers_request_path(@request), alert: "불만 내용을 입력해주세요."
      return
    end

    @request.update!(
      customer_complaint: complaint_text,
      complaint_submitted_at: Time.current
    )
    redirect_to customers_request_path(@request), notice: "불만 사항이 접수되었습니다. 관리자가 빠르게 처리하겠습니다."
  end

  private

  def set_request
    @request = current_user.requests.find(params[:id])
  end

  def request_params
    params.require(:request).permit(
      :symptom_type, :building_type, :address, :detailed_address,
      :floor_info, :description, :preferred_date, photos: [], videos: []
    )
  end
end
