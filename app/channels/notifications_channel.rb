class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # 현재 사용자의 알림 스트림 구독
    stream_for current_user if current_user
  end

  def unsubscribed
    # 구독 해제 시 정리 작업
    stop_all_streams
  end

  def mark_as_read(data)
    notification = current_user.notifications.find_by(id: data["id"])
    notification&.mark_as_read!
  end

  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)
  end
end
