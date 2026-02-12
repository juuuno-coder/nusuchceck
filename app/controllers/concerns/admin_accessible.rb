module AdminAccessible
  extend ActiveSupport::Concern

  included do
    before_action :ensure_admin!
  end

  private

  def ensure_admin!
    unless current_user&.admin?
      flash[:alert] = "관리자 전용 기능입니다."
      redirect_to root_path
    end
  end
end
