module MasterAccessible
  extend ActiveSupport::Concern

  included do
    before_action :ensure_master!
  end

  private

  def ensure_master!
    unless current_user&.master?
      flash[:alert] = "마스터 전용 기능입니다."
      redirect_to root_path
    end
  end
end
