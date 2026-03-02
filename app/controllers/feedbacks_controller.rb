class FeedbacksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.user = current_user if user_signed_in?

    if @feedback.save
      # 관리자에게 알림 (선택사항)
      # NotificationService.notify_admin_new_feedback(@feedback) rescue nil

      redirect_to root_path, notice: "소중한 의견 감사합니다! 검토 후 연락드리겠습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :category, :message)
  end
end
