class SubscriptionMailer < ApplicationMailer
  def new_subscriber(subscription)
    @subscription = subscription
    @admin_email = "juuuno@naver.com"

    mail(
      to: @admin_email,
      subject: "[누수체크] 새로운 출시 알림 신청: #{subscription.email}"
    )
  end
end
