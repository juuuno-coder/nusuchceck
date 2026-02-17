class Expert::BaseController < ApplicationController
  layout "expert"
  skip_before_action :authenticate_user!, only: [:index]

  private

  def ensure_master!
    unless current_user&.master?
      flash[:alert] = "전문가 전용 페이지입니다."
      redirect_to expert_root_path
    end
  end
end
