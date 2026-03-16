class SurveysController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create], raise: false

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)
    @survey.user = current_user if user_signed_in?

    if @survey.save
      redirect_to root_path, notice: "설문에 참여해주셔서 감사합니다!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def survey_params
    params.require(:survey).permit(:need_app, :reason, :contact_info, :user_type)
  end
end
