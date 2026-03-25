class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :kakao

  def kakao
    auth = request.env["omniauth.auth"]
    Rails.logger.info "[KAKAO] auth.provider=#{auth&.provider} uid=#{auth&.uid} email=#{auth&.info&.email} name=#{auth&.info&.name}"

    @user = User.from_omniauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "카카오") if is_navigational_format?
    else
      Rails.logger.error "[KAKAO] 유저 생성 실패: #{@user.errors.full_messages.join(', ')}"
      session["devise.kakao_data"] = auth.except(:extra)
      redirect_to new_user_registration_url, alert: "카카오 로그인에 실패했습니다: #{@user.errors.full_messages.join(', ')}"
    end
  end

  def failure
    redirect_to root_path, alert: "카카오 로그인에 실패했습니다. 다시 시도해주세요."
  end
end
