class Admin::EscrowTransactionsController < ApplicationController
  include AdminAccessible

  before_action :set_transaction, only: [:show, :release_payment, :refund]

  def index
    @q = EscrowTransaction.ransack(params[:q])
    @transactions = @q.result.includes(:customer, :master, :request).order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def release_payment
    authorize @transaction
    EscrowService.new(@transaction.request).release!
    redirect_to admin_escrow_transaction_path(@transaction), notice: "대금이 지급되었습니다."
  rescue => e
    redirect_to admin_escrow_transaction_path(@transaction), alert: "대금 지급 실패: #{e.message}"
  end

  def refund
    authorize @transaction
    EscrowService.new(@transaction.request).refund!
    redirect_to admin_escrow_transaction_path(@transaction), notice: "환불이 처리되었습니다."
  rescue => e
    redirect_to admin_escrow_transaction_path(@transaction), alert: "환불 실패: #{e.message}"
  end

  private

  def set_transaction
    @transaction = EscrowTransaction.find(params[:id])
  end
end
