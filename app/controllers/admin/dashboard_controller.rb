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

    # 주간 신고 추이 (7일)
    @weekly_requests = Request.where("created_at >= ?", 7.days.ago)
                              .group("DATE(created_at)")
                              .order("DATE(created_at)")
                              .count

    # 30일 신고 추이 (차트용)
    @monthly_requests = Request.where("created_at >= ?", 30.days.ago)
                               .group("DATE(created_at)")
                               .order("DATE(created_at)")
                               .count

    # 6개월 수수료 수익 추이
    @monthly_revenue = EscrowTransaction.where(
                         status: ["released", "settled"],
                         created_at: 6.months.ago..Time.current
                       )
                       .group("TO_CHAR(created_at, 'YYYY-MM')")
                       .order("TO_CHAR(created_at, 'YYYY-MM')")
                       .sum(:platform_fee)

    # 증상 유형별 분포
    @symptom_distribution = Request.group(:symptom_type).count

    # 완료 건수
    @completed_count = Request.where(status: "closed").count
  end
end
