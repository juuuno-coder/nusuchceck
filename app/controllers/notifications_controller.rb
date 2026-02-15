class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications
                                 .recent
                                 .page(params[:page])
                                 .per(20)
    @unread_count = current_user.notifications.unread.count
  end

  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.mark_as_read!

    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_back(fallback_location: notifications_path) }
    end
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)

    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to notifications_path, notice: "모든 알림을 읽음 처리했습니다." }
    end
  end

  def destroy
    notification = current_user.notifications.find(params[:id])
    notification.destroy

    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_to notifications_path, notice: "알림을 삭제했습니다." }
    end
  end
end
