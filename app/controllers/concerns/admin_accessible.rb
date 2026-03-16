module AdminAccessible
  extend ActiveSupport::Concern

  included do
    before_action :ensure_admin!
  end

  private

  def ensure_admin!
    unless user_signed_in?
      flash[:alert] = "로그인이 필요합니다."
      redirect_to new_user_session_path
      return
    end
    unless current_user.admin?
      flash[:alert] = "관리자 전용 기능입니다."
      redirect_to root_path
    end
  end
end
