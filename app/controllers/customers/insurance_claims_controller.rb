class Customers::InsuranceClaimsController < ApplicationController
  include CustomerAccessible

  before_action :set_insurance_claim, only: [:show, :edit, :update, :submit_claim, :download_pdf]
  before_action :set_request, only: [:new, :create], if: -> { params[:request_id].present? }

  def index
    @q = current_user.insurance_claims.ransack(params[:q])
    @insurance_claims = @q.result.recent.page(params[:page])
  end

  def show
    authorize @insurance_claim
  end

  def new
    @insurance_claim = current_user.insurance_claims.build
    if @request
      @insurance_claim.request = @request
      @insurance_claim.prefill_from_request!
    end
  end

  def create
    @insurance_claim = current_user.insurance_claims.build(insurance_claim_params)
    @insurance_claim.request = @request if @request

    if @insurance_claim.save
      redirect_to customers_insurance_claim_path(@insurance_claim),
                  notice: "보험 신청서가 저장되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @insurance_claim
  end

  def update
    authorize @insurance_claim
    if @insurance_claim.update(insurance_claim_params)
      redirect_to customers_insurance_claim_path(@insurance_claim),
                  notice: "보험 신청서가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def submit_claim
    authorize @insurance_claim
    if @insurance_claim.may_submit_claim?
      @insurance_claim.submit_claim!
      redirect_to customers_insurance_claim_path(@insurance_claim),
                  notice: "보험 신청이 완료되었습니다."
    else
      redirect_to customers_insurance_claim_path(@insurance_claim),
                  alert: "현재 상태에서는 신청할 수 없습니다."
    end
  end

  def download_pdf
    authorize @insurance_claim
    pdf = InsuranceClaimPdfService.new(@insurance_claim).generate
    send_data pdf.render,
              filename: "보험신청서_#{@insurance_claim.claim_number}.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  private

  def set_insurance_claim
    @insurance_claim = current_user.insurance_claims.find(params[:id])
  end

  def set_request
    @request = current_user.requests.find(params[:request_id])
  end

  def insurance_claim_params
    params.require(:insurance_claim).permit(
      :applicant_name, :applicant_phone, :applicant_email,
      :birth_date, :incident_address, :incident_detail_address,
      :incident_date, :incident_description, :damage_type,
      :estimated_damage_amount, :insurance_company, :policy_number,
      :victim_name, :victim_phone, :victim_address,
      supporting_documents: []
    )
  end
end
