class Admin::SurveysController < ApplicationController
  include AdminAccessible

  def index
    @q = Survey.ransack(params[:q])
    @surveys = @q.result.includes(:user).recent.page(params[:page]).per(20)

    @stats = {
      total: Survey.count,
      need_yes: Survey.need_yes.count,
      need_no: Survey.need_no.count,
      need_maybe: Survey.need_maybe.count,
      customers: Survey.where(user_type: 'customer').count,
      masters: Survey.where(user_type: 'master').count
    }
  end

  def show
    @survey = Survey.find(params[:id])
  end
end
