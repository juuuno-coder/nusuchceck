module CustomerAccessible
  extend ActiveSupport::Concern

  included do
    before_action :ensure_customer!
  end

  private

  def ensure_customer!
    unless current_user&.customer?
      flash[:alert] = "고객 전용 기능입니다."
      redirect_to root_path
    end
  end
end
