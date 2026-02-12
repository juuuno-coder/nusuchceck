class Masters::ProfilesController < ApplicationController
  include MasterAccessible

  before_action :set_profile

  def show
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to masters_profile_path, notice: "프로필이 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_profile
    @profile = current_user.master_profile || current_user.create_master_profile
  end

  def profile_params
    params.require(:master_profile).permit(
      :license_number, :license_type, :experience_years,
      :bank_name, :account_number, :account_holder, :bio,
      equipment: [], service_areas: []
    )
  end
end
