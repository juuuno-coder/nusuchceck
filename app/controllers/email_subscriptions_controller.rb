class EmailSubscriptionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    @subscription = EmailSubscription.new(email: params[:email])

    if @subscription.save
      # juuuno@naver.com으로 알림 발송
      SubscriptionMailer.new_subscriber(@subscription).deliver_later

      redirect_to root_path, notice: "출시 알림 신청이 완료되었습니다! 🎉"
    else
      redirect_to root_path, alert: "이메일 주소를 확인해주세요. #{@subscription.errors.full_messages.join(', ')}"
    end
  end
end
