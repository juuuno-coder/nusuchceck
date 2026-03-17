class ExpertInquiryMailer < ApplicationMailer
  def inquiry_received(name:, phone:, email:, message:)
    @name    = name
    @phone   = phone
    @email   = email
    @message = message
    @received_at = Time.current.strftime("%Y-%m-%d %H:%M")

    mail(
      to: ENV.fetch("SMTP_USERNAME", "juuuno1116@gmail.com"),
      subject: "[누수체크] 전문가 등록 문의 - #{@name}"
    )
  end
end
