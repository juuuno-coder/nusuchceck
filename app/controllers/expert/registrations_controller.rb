class Expert::RegistrationsController < Devise::RegistrationsController
  layout "expert"
  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :address, :type])
  end

  # 전문가(마스터)로 강제 설정
  def build_resource(hash = {})
    hash[:type] = "Master"
    super
  end

  def after_sign_up_path_for(resource)
    edit_masters_profile_path
  end

  def after_inactive_sign_up_path_for(resource)
    expert_root_path
  end
end
