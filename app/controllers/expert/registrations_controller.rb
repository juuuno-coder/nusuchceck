class Expert::RegistrationsController < Devise::RegistrationsController
  layout "expert"
  before_action :redirect_to_inquiry, only: [:new, :create]
  before_action :configure_sign_up_params, only: [:create]

  private

  def redirect_to_inquiry
    # 승인된 문의의 토큰이 있고, 아직 가입에 사용되지 않은 경우만 허용
    inquiry = ExpertInquiry.approved.find_by(id: params[:token])
    return if inquiry.present? && inquiry.status == "approved"
    redirect_to expert_inquiry_path
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name, :phone, :address, :type,
      master_profile_attributes: [
        :experience_years, :bio,
        specialty_types: [],
        service_areas: []
      ]
    ])
  end

  # 전문가(마스터)로 강제 설정, registered 상태로 설정
  def build_resource(hash = {})
    hash[:type] = "Master"
    hash[:account_status] = "registered"
    super
  end

  def after_sign_up_path_for(resource)
    # 승인 토큰 소비 — 같은 링크로 중복 가입 방지
    if params[:token].present?
      ExpertInquiry.approved.find_by(id: params[:token])&.update_columns(status: "registered")
    end

    # 관리자에게 새 전문가 가입 알림
    begin
      admins = User.where(role: :admin).select(:id, :name, :email)
      admins.find_each do |admin|
        NotificationService.notify(
          recipient: admin,
          action: "new_master_signup",
          message: "새 전문가 #{resource.name}님이 가입했습니다. 프로필을 검토하고 승인해주세요.",
          notifiable: resource
        )
      end
    rescue => e
      Rails.logger.error "전문가 가입 알림 실패: #{e.message}"
    end
    edit_masters_profile_path
  end

  def after_inactive_sign_up_path_for(resource)
    expert_root_path
  end
end
