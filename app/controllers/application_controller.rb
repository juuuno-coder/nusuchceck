class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include HotwireNativeApp

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  helper_method :current_customer, :current_master

  after_action :track_page_view

  SKIP_TRACKING_CONTROLLERS = %w[
    admin/dashboard admin/masters admin/requests admin/insurance_claims
    admin/service_zones api/ai_chat
  ].freeze

  def current_customer
    current_user if current_user&.customer?
  end

  def current_master
    current_user if current_user&.master?
  end

  private

  def track_page_view
    return if SKIP_TRACKING_CONTROLLERS.include?(params[:controller])
    return unless request.format.html?
    return if request.path.start_with?("/rails/", "/cable", "/assets/", "/packs/")
    return unless response.successful?

    PageView.create!(
      viewed_on:       Date.current,
      path:            request.path,
      controller_name: params[:controller],
      action_name:     params[:action],
      user_id:         current_user&.id
    )
  rescue StandardError
    # 트래킹 실패가 요청에 영향을 주지 않도록
  end

  def record_not_found
    respond_to do |format|
      format.html do
        flash[:alert] = "요청하신 정보를 찾을 수 없습니다."
        redirect_back(fallback_location: root_path)
      end
      format.json { render json: { error: "리소스를 찾을 수 없습니다." }, status: :not_found }
    end
  end

  def parameter_missing(exception)
    respond_to do |format|
      format.html do
        flash[:alert] = "필수 파라미터가 누락되었습니다: #{exception.param}"
        redirect_back(fallback_location: root_path)
      end
      format.json { render json: { error: "필수 파라미터 누락: #{exception.param}" }, status: :bad_request }
    end
  end

  def user_not_authorized
    flash[:alert] = "이 작업을 수행할 권한이 없습니다."
    redirect_back(fallback_location: root_path)
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_path
    elsif resource.master?
      expert_dashboard_path  # 전문가 대시보드
    else
      customers_dashboard_path  # 고객 대시보드
    end
  end
end
