class ApplicationMailer < ActionMailer::Base
  default from: "noreply@nusucheck.kr"
  layout "mailer"

  ADMIN_EMAILS = [
    ENV.fetch("SMTP_USERNAME", "juuuno1116@gmail.com"),
    "cleanmentor2@gmail.com"
  ].uniq.freeze
end
