class Admin::MastersController < ApplicationController
  include AdminAccessible

  before_action :set_master, only: [:show, :edit, :update, :verify, :reject, :approve_insurance, :reject_insurance, :approve_profile, :flag_profile]

  def index
    @q = Master.ransack(params[:q])
    @masters = @q.result.includes(:master_profile, :reviews).page(params[:page])
  end

  def show
    @profile = @master.master_profile
    @recent_requests = @master.assigned_requests.includes(:customer, :escrow_transactions).recent.limit(10)
    @reviews = @master.reviews.recent.limit(5)
  end

  def edit
    @profile = @master.master_profile || @master.build_master_profile
  end

  def update
    @profile = @master.master_profile || @master.build_master_profile

    # 콤마 구분 텍스트를 배열로 변환
    %i[equipment service_areas certifications].each do |field|
      if params.dig(:master_profile, field).is_a?(String)
        params[:master_profile][field] = params[:master_profile][field].split(",").map(&:strip).reject(&:blank?)
      end
    end

    if @profile.update(admin_profile_params)
      @profile.construction_photos.attach(params[:master_profile][:work_photos]) if params.dig(:master_profile, :work_photos).present?
      redirect_to admin_master_path(@master), notice: "#{@master.name} 프로필이 수정됐어요."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def verify
    @master.master_profile.verify!
    redirect_to admin_master_path(@master), notice: "#{@master.name} 마스터가 인증되었습니다."
  end

  def reject
    @master.master_profile.reject!
    redirect_to admin_master_path(@master), notice: "#{@master.name} 마스터 인증이 거부되었습니다."
  end

  def approve_insurance
    profile = @master.master_profile
    ocr_data = profile.insurance_ocr_data&.symbolize_keys || {}
    ocr_data[:valid_until] = Date.parse(ocr_data[:valid_until].to_s) rescue nil
    profile.approve_insurance!(ocr_data)

    NotificationService.notify(
      recipient: @master,
      action: "insurance_approved",
      message: "배상책임보험 인증이 완료됐어요! 프로필에 보험 인증 뱃지가 표시돼요.",
      notifiable: profile
    ) rescue nil

    redirect_to admin_master_path(@master), notice: "#{@master.name} 마스터 보험 인증이 승인됐어요."
  end

  def reject_insurance
    @master.master_profile.reject_insurance!

    NotificationService.notify(
      recipient: @master,
      action: "insurance_rejected",
      message: "보험 인증 서류를 확인하지 못했어요. 선명한 보험가입증명서로 다시 제출해주세요.",
      notifiable: @master.master_profile
    ) rescue nil

    redirect_to admin_master_path(@master), alert: "#{@master.name} 마스터 보험 인증이 거절됐어요."
  end

  def approve_profile
    notes = params[:review_notes].to_s.strip.presence
    @master.master_profile.update!(
      profile_review_status: "approved",
      profile_reviewed_at: Time.current,
      profile_review_notes: notes
    )
    NotificationService.notify(
      recipient: @master,
      action: "profile_approved",
      message: "프로필 점검이 완료됐어요! 고객에게 프로필이 공개돼요.",
      notifiable: @master.master_profile
    ) rescue nil
    redirect_to admin_master_path(@master), notice: "#{@master.name} 프로필이 승인됐어요."
  end

  def flag_profile
    notes = params[:review_notes].to_s.strip.presence
    @master.master_profile.update!(
      profile_review_status: "flagged",
      profile_reviewed_at: Time.current,
      profile_review_notes: notes
    )
    NotificationService.notify(
      recipient: @master,
      action: "profile_flagged",
      message: "프로필 수정이 필요해요. #{notes.present? ? "사유: #{notes}" : "관리자에게 문의해주세요."}",
      notifiable: @master.master_profile
    ) rescue nil
    redirect_to admin_master_path(@master), notice: "#{@master.name} 프로필 수정 요청을 보냈어요."
  end

  private

  def set_master
    @master = Master.find(params[:id])
  end

  def admin_profile_params
    params.require(:master_profile).permit(
      :license_number, :license_type, :experience_years,
      :bank_name, :account_number, :account_holder,
      :bio, :tagline, :intro_video_url, :profile_photo,
      equipment: [], service_areas: [], certifications: []
    )
  end
end
