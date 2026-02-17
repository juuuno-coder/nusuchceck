class Admin::DashboardController < ApplicationController
  include AdminAccessible

  def index
    # 신고 통계
    @total_requests = Request.count
    @active_requests = Request.active.count
    @recent_requests = Request.recent.limit(10)

    # 마스터 통계
    @total_masters = Master.count
    @verified_masters = MasterProfile.verified.count

    # 에스크로 통계
    @pending_escrows = EscrowTransaction.where(status: "deposited").count
    @revenue = EscrowTransaction.where(status: ["released", "settled"]).sum(:platform_fee)

    # 보험청구 통계
    @total_insurance_claims = InsuranceClaim.count
    @pending_insurance_claims = InsuranceClaim.where(status: ["draft", "pending_customer_review"]).count
    @submitted_insurance_claims = InsuranceClaim.where(status: "submitted").count
    @recent_insurance_claims = InsuranceClaim.recent.limit(5)

    # 주간 신고 추이
    @weekly_requests = Request.where("created_at >= ?", 7.days.ago)
                              .group("DATE(created_at)")
                              .order("DATE(created_at)")
                              .count
  end
end
