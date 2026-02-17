class Admin::EscrowTransactionsController < ApplicationController
  include AdminAccessible

  before_action :set_escrow_transaction, only: [:show, :release_payment, :refund]

  def index
    @q = EscrowTransaction.ransack(params[:q])
    @escrow_transactions = @q.result.includes(:customer, :master, :request).order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def release_payment
    authorize @escrow_transaction
    EscrowService.new(@escrow_transaction.request).release!
    redirect_to admin_escrow_transaction_path(@escrow_transaction), notice: "대금이 지급되었습니다."
  rescue => e
    redirect_to admin_escrow_transaction_path(@escrow_transaction), alert: "대금 지급 실패: #{e.message}"
  end

  def refund
    authorize @escrow_transaction
    EscrowService.new(@escrow_transaction.request).refund!
    redirect_to admin_escrow_transaction_path(@escrow_transaction), notice: "환불이 처리되었습니다."
  rescue => e
    redirect_to admin_escrow_transaction_path(@escrow_transaction), alert: "환불 실패: #{e.message}"
  end

  private

  def set_escrow_transaction
    @escrow_transaction = EscrowTransaction.find(params[:id])
  end
end
