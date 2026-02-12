class Customers::RequestsController < ApplicationController
  include CustomerAccessible

  before_action :set_request, only: [:show, :cancel, :accept_estimate, :deposit_escrow, :confirm_completion]

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

  def deposit_escrow
    authorize @request
    estimate = @request.accepted_estimate
    unless estimate
      redirect_to customers_request_path(@request), alert: "수락된 견적이 없습니다."
      return
    end

    escrow = EscrowService.new(@request).create_and_deposit!(
      amount: estimate.total_amount,
      payment_method: params[:payment_method] || "card"
    )

    if escrow.deposited?
      @request.deposit_escrow!
      redirect_to customers_request_path(@request), notice: "에스크로 입금이 완료되었습니다."
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

  private

  def set_request
    @request = current_user.requests.find(params[:id])
  end

  def request_params
    params.require(:request).permit(
      :symptom_type, :building_type, :address, :detailed_address,
      :floor_info, :description, :preferred_date, photos: []
    )
  end
end
