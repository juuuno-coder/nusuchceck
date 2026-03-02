class Admin::FeedbacksController < ApplicationController
  include AdminAccessible

  def index
    @q = Feedback.ransack(params[:q])
    @feedbacks = @q.result.includes(:user).recent.page(params[:page]).per(20)

    @stats = {
      total: Feedback.count,
      pending: Feedback.status_pending.count,
      reviewed: Feedback.status_reviewed.count,
      resolved: Feedback.status_resolved.count
    }
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  def mark_reviewed
    @feedback = Feedback.find(params[:id])
    @feedback.update!(status: 'reviewed')
    redirect_to admin_feedbacks_path, notice: "검토 완료로 표시했습니다."
  end

  def mark_resolved
    @feedback = Feedback.find(params[:id])
    @feedback.update!(status: 'resolved')
    redirect_to admin_feedbacks_path, notice: "해결 완료로 표시했습니다."
  end
end
