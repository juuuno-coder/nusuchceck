# frozen_string_literal: true

class InsuranceSubmissionMailer < ApplicationMailer
  # 보험사에 청구서 제출
  def submit_to_company(insurance_claim:, company_info:, pdf_data:)
    @insurance_claim = insurance_claim
    @company_info = company_info

    # PDF 첨부
    attachments["보험청구서_#{@insurance_claim.claim_number}.pdf"] = pdf_data

    # 피해 사진 첨부 (Active Storage)
    if @insurance_claim.supporting_documents.attached?
      @insurance_claim.supporting_documents.each_with_index do |document, index|
        attachments["피해사진_#{index + 1}.#{document.filename.extension}"] = document.download
      end
    end

    mail(
      to: company_info[:email],
      subject: "[누수체크] 일상배상책임보험 청구 - #{@insurance_claim.claim_number}",
      from: "noreply@nusucheck.com" # 실제 도메인으로 교체 필요
    )
  end
end
