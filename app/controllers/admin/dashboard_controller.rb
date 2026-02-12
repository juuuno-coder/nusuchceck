class Admin::DashboardController < ApplicationController
  include AdminAccessible

  def index
    @total_requests = Request.count
    @active_requests = Request.active.count
    @total_masters = Master.count
    @verified_masters = MasterProfile.verified.count
    @pending_escrows = EscrowTransaction.where(status: "deposited").count
    @recent_requests = Request.recent.limit(10)
    @revenue = EscrowTransaction.where(status: ["released", "settled"]).sum(:platform_fee)
  end
end
