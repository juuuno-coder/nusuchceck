class Masters::RequestsController < ApplicationController
  include MasterAccessible

  before_action :set_request, only: [
    :show, :visit, :arrive, :detection_complete, :detection_fail,
    :submit_estimate, :start_construction, :complete_construction
  ]

  def index
    @q = current_user.assigned_requests.ransack(params[:q])
    @requests = @q.result.recent.page(params[:page])
  end

  def show
    authorize @request
  end

  def visit
    authorize @request
    @request.visit!
    redirect_to masters_request_path(@request), notice: "방문을 시작했습니다."
  rescue AASM::InvalidTransition => e
    redirect_to masters_request_path(@request), alert: "상태 변경 실패: #{e.message}"
  end

  def arrive
    authorize @request
    @request.arrive!
    redirect_to masters_request_path(@request), notice: "현장에 도착했습니다. 탐지를 시작합니다."
  rescue AASM::InvalidTransition => e
    redirect_to masters_request_path(@request), alert: "상태 변경 실패: #{e.message}"
  end

  def detection_complete
    authorize @request
    @request.update!(detection_result: :leak_confirmed, detection_notes: params[:detection_notes])
    @request.detection_complete!
    redirect_to masters_request_path(@request), notice: "누수가 확인되었습니다. 견적을 작성해주세요."
  rescue AASM::InvalidTransition => e
    redirect_to masters_request_path(@request), alert: "상태 변경 실패: #{e.message}"
  end

  def detection_fail
    authorize @request
    @request.detection_fail!
    redirect_to masters_request_path(@request), notice: "누수가 확인되지 않았습니다."
  rescue AASM::InvalidTransition => e
    redirect_to masters_request_path(@request), alert: "상태 변경 실패: #{e.message}"
  end

  def submit_estimate
    authorize @request
    @request.submit_estimate!
    redirect_to masters_request_path(@request), notice: "견적이 제출되었습니다."
  rescue AASM::InvalidTransition => e
    redirect_to masters_request_path(@request), alert: "견적 제출 실패: #{e.message}"
  end

  def start_construction
    authorize @request
    @request.start_construction!
    redirect_to masters_request_path(@request), notice: "공사를 시작합니다."
  rescue AASM::InvalidTransition => e
    redirect_to masters_request_path(@request), alert: "상태 변경 실패: #{e.message}"
  end

  def complete_construction
    authorize @request
    @request.complete_construction!
    redirect_to masters_request_path(@request), notice: "공사가 완료되었습니다. 고객 확인을 기다립니다."
  rescue AASM::InvalidTransition => e
    redirect_to masters_request_path(@request), alert: "상태 변경 실패: #{e.message}"
  end

  private

  def set_request
    @request = current_user.assigned_requests.find(params[:id])
  end
end
