class LeakInspectionsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_inspection, only: [:show]

  def new
    @inspection = LeakInspection.new
  end

  def create
    @inspection = LeakInspection.new(inspection_params)
    @inspection.customer = current_user if current_user.is_a?(Customer)

    if @inspection.save
      begin
        LeakInspectionService.new(@inspection).analyze!
        redirect_to leak_inspection_path(@inspection, token: @inspection.session_token),
                    notice: "AI 분석이 완료되었습니다."
      rescue LeakInspectionService::AnalysisError
        redirect_to leak_inspection_path(@inspection, token: @inspection.session_token),
                    alert: "분석 중 오류가 발생했습니다. 다시 시도해 주세요."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_inspection
    @inspection = if current_user.is_a?(Customer)
                    LeakInspection.find(params[:id])
                  else
                    LeakInspection.find_by!(id: params[:id], session_token: params[:token])
                  end
  end

  def inspection_params
    params.require(:leak_inspection).permit(:photo, :location_description, :symptom_type)
  end
end
