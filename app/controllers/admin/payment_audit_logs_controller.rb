# frozen_string_literal: true

class Admin::PaymentAuditLogsController < ApplicationController
  include AdminAccessible

  def index
    @q = PaymentAuditLog.ransack(params[:q])

    # 기본 정렬: 최신순
    @q.sorts = "created_at desc" if @q.sorts.empty?

    @payment_audit_logs = @q.result(distinct: true)
                            .includes(:escrow_transaction, :user)
                            .page(params[:page])
                            .per(50)

    # 통계 (캐시 5분)
    @stats = Rails.cache.fetch("admin:payment_audit_stats", expires_in: 5.minutes) do
      {
        total_attempts: PaymentAuditLog.where(action: "attempt").count,
        total_success: PaymentAuditLog.where(action: "success").count,
        total_fail: PaymentAuditLog.where(action: "fail").count,
        total_refund: PaymentAuditLog.where(action: "refund").count,
        total_cancel: PaymentAuditLog.where(action: "cancel").count,
        success_rate: PaymentAuditLog.success_rate
      }
    end
  end

  def show
    @payment_audit_log = PaymentAuditLog.find(params[:id])
  end
end
