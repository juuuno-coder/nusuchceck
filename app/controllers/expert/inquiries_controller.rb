class Expert::InquiriesController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  def new
  end

  def create
    name    = params[:name].to_s.strip
    phone   = params[:phone].to_s.strip
    email   = params[:email].to_s.strip
    message = params[:message].to_s.strip

    ExpertInquiryMailer.inquiry_received(name: name, phone: phone, email: email, message: message).deliver_later

    redirect_to expert_inquiry_path, notice: "문의가 접수되었습니다. 검토 후 개별 연락드리겠습니다 😊"
  rescue => e
    Rails.logger.error "Expert inquiry email failed: #{e.message}"
    redirect_to expert_inquiry_path, notice: "문의가 접수되었습니다. 검토 후 개별 연락드리겠습니다 😊"
  end
end
