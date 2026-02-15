class InsuranceClaimMailer < ApplicationMailer
  # 마스터가 고객에게 검토 요청을 보낼 때
  def review_request(insurance_claim)
    @insurance_claim = insurance_claim
    @customer = insurance_claim.customer
    @master = insurance_claim.prepared_by_master

    mail(
      to: @customer.email,
      subject: "[누수체크] #{@master.name} 전문가가 보험청구서를 작성했어요"
    )
  end

  # 고객이 승인했을 때 마스터에게 알림
  def customer_approved(insurance_claim)
    @insurance_claim = insurance_claim
    @customer = insurance_claim.customer
    @master = insurance_claim.prepared_by_master

    mail(
      to: @master.email,
      subject: "[누수체크] #{@customer.name}님이 보험청구서를 승인했어요"
    )
  end

  # 고객이 수정 요청했을 때 마스터에게 알림
  def change_requested(insurance_claim)
    @insurance_claim = insurance_claim
    @customer = insurance_claim.customer
    @master = insurance_claim.prepared_by_master

    mail(
      to: @master.email,
      subject: "[누수체크] #{@customer.name}님이 보험청구서 수정을 요청했어요"
    )
  end
end
