class Admin::RequestsController < ApplicationController
  include AdminAccessible

  before_action :set_request, only: [:show, :publish, :assign_master, :close_no_charge, :finalize]

  def index
    @q = Request.ransack(params[:q])
    @requests = @q.result.includes(:customer, :master).recent.page(params[:page])
  end

  def show
    @available_masters = Master.joins(:master_profile)
                               .where(master_profiles: { verified: true })
                               .order(:name)
  end

  def publish
    authorize @request
    @request.publish!
    redirect_to admin_request_path(@request), notice: "공개 오더 풀에 등록했습니다. 전문가가 선택할 수 있습니다."
  rescue AASM::InvalidTransition => e
    redirect_to admin_request_path(@request), alert: "공개 등록 실패: #{e.message}"
  end

  def assign_master
    authorize @request
    master = Master.find(params[:master_id])
    @request.assign!(master: master)
    NotificationService.notify_request_assigned(@request) rescue nil
    redirect_to admin_request_path(@request), notice: "#{master.name} 마스터가 직접 배정되었습니다."
  rescue AASM::InvalidTransition => e
    redirect_to admin_request_path(@request), alert: "마스터 배정 실패: #{e.message}"
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_request_path(@request), alert: "존재하지 않는 마스터입니다."
  end

  def close_no_charge
    authorize @request
    @request.close_no_charge!
    redirect_to admin_request_path(@request), notice: "비용 미청구로 종료되었습니다."
  rescue AASM::InvalidTransition => e
    redirect_to admin_request_path(@request), alert: "종료 실패: #{e.message}"
  end

  def finalize
    authorize @request
    @request.finalize!
    redirect_to admin_request_path(@request), notice: "최종 종료 처리되었습니다."
  rescue AASM::InvalidTransition => e
    redirect_to admin_request_path(@request), alert: "종료 실패: #{e.message}"
  end

  private

  def set_request
    @request = Request.find(params[:id])
  end
end
