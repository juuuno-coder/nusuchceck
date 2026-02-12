class Admin::MastersController < ApplicationController
  include AdminAccessible

  before_action :set_master, only: [:show, :verify, :reject]

  def index
    @q = Master.ransack(params[:q])
    @masters = @q.result.includes(:master_profile).page(params[:page])
  end

  def show
    @profile = @master.master_profile
    @recent_requests = @master.assigned_requests.recent.limit(10)
    @reviews = @master.reviews.recent.limit(5)
  end

  def verify
    @master.master_profile.verify!
    redirect_to admin_master_path(@master), notice: "#{@master.name} 마스터가 인증되었습니다."
  end

  def reject
    @master.master_profile.reject!
    redirect_to admin_master_path(@master), notice: "#{@master.name} 마스터 인증이 거부되었습니다."
  end

  private

  def set_master
    @master = Master.find(params[:id])
  end
end
