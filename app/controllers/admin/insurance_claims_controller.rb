class Admin::InsuranceClaimsController < ApplicationController
  include AdminAccessible

  before_action :set_insurance_claim, only: [:show, :start_review, :approve, :reject, :complete]

  def index
    @q = InsuranceClaim.ransack(params[:q])
    @insurance_claims = @q.result.recent.page(params[:page])
  end

  def show
  end

  def start_review
    @insurance_claim.start_review!
    redirect_to admin_insurance_claim_path(@insurance_claim), notice: "심사가 시작되었습니다."
  rescue AASM::InvalidTransition
    redirect_to admin_insurance_claim_path(@insurance_claim), alert: "상태 전환에 실패했습니다."
  end

  def approve
    @insurance_claim.approve!
    redirect_to admin_insurance_claim_path(@insurance_claim), notice: "승인되었습니다."
  rescue AASM::InvalidTransition
    redirect_to admin_insurance_claim_path(@insurance_claim), alert: "상태 전환에 실패했습니다."
  end

  def reject
    @insurance_claim.reject!
    redirect_to admin_insurance_claim_path(@insurance_claim), alert: "반려되었습니다."
  rescue AASM::InvalidTransition
    redirect_to admin_insurance_claim_path(@insurance_claim), alert: "상태 전환에 실패했습니다."
  end

  def complete
    @insurance_claim.complete!
    redirect_to admin_insurance_claim_path(@insurance_claim), notice: "처리 완료되었습니다."
  rescue AASM::InvalidTransition
    redirect_to admin_insurance_claim_path(@insurance_claim), alert: "상태 전환에 실패했습니다."
  end

  private

  def set_insurance_claim
    @insurance_claim = InsuranceClaim.find(params[:id])
  end
end
