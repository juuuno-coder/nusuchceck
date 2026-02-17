class Expert::SettlementsController < Expert::BaseController
  before_action :authenticate_user!
  before_action :ensure_master!

  def index
    @q = current_user.escrow_transactions.ransack(params[:q])

    # 상태 필터
    status_filter = params[:status].presence
    base_scope = status_filter.present? ?
      current_user.escrow_transactions.where(status: status_filter) :
      current_user.escrow_transactions

    @escrow_transactions = base_scope.order(created_at: :desc).page(params[:page]).per(20)

    # 정산 요약
    @total_pending   = current_user.escrow_transactions.where(status: %w[deposited held]).sum(:amount)
    @total_released  = current_user.escrow_transactions.where(status: :released).sum(:master_payout)
    @total_settled   = current_user.escrow_transactions.where(status: :settled).sum(:master_payout)
    @total_refunded  = current_user.escrow_transactions.where(status: :refunded).sum(:amount)

    # 이번 달 정산
    @this_month_settled = current_user.escrow_transactions
                                      .where(status: :settled)
                                      .where(updated_at: Time.current.beginning_of_month..)
                                      .sum(:master_payout)
  end
end
