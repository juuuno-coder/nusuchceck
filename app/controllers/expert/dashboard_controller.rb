class Expert::DashboardController < Expert::BaseController
  before_action :authenticate_user!
  before_action :ensure_master!

  def index
    # 진행 중인 오더
    @active_requests = current_user.assigned_requests
                                   .where.not(status: %w[closed cancelled])
                                   .order(created_at: :desc)
                                   .limit(5)

    # 오늘 방문 예정
    @todays_visits = current_user.assigned_requests
                                 .where(status: %w[assigned visiting])
                                 .where(preferred_date: Time.current.all_day)

    # 이번 달 완료 건수
    @monthly_completed = current_user.assigned_requests
                                     .where(status: :closed)
                                     .where(closed_at: Time.current.beginning_of_month..)
                                     .count

    # 미수령 금액 (released 상태 에스크로)
    @pending_payout = current_user.escrow_transactions
                                  .where(status: :released)
                                  .sum(:master_payout)

    # 이번 달 정산 완료 금액
    @monthly_settled = current_user.escrow_transactions
                                   .where(status: :settled)
                                   .where(created_at: Time.current.beginning_of_month..)
                                   .sum(:master_payout)

    # 공개 오더 수
    @open_orders_count = Request.open_orders.count

    # 최근 완료 오더 (포트폴리오용)
    @recent_completed = current_user.assigned_requests
                                    .where(status: :closed)
                                    .order(closed_at: :desc)
                                    .limit(3)
  end
end
