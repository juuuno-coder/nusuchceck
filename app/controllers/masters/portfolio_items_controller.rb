# frozen_string_literal: true

class Masters::PortfolioItemsController < ApplicationController
  include MasterAccessible
  before_action :set_profile
  before_action :set_item, only: [:update, :destroy, :toggle_pin]

  def index
    @items = @profile.portfolio_items.ordered
  end

  def create
    @item = @profile.portfolio_items.build(item_params)
    @item.position = @profile.portfolio_items.count

    if @item.save
      redirect_to masters_portfolio_items_path, notice: "시공 사례가 추가됐어요."
    else
      redirect_to masters_portfolio_items_path, alert: "업로드에 실패했어요."
    end
  end

  def update
    if @item.update(item_params)
      redirect_to masters_portfolio_items_path, notice: "수정됐어요."
    else
      redirect_to masters_portfolio_items_path, alert: "수정에 실패했어요."
    end
  end

  def destroy
    @item.destroy
    redirect_to masters_portfolio_items_path, notice: "삭제됐어요."
  end

  def toggle_pin
    @item.update(pinned: !@item.pinned)
    redirect_to masters_portfolio_items_path, notice: @item.pinned? ? "고정했어요." : "고정 해제했어요."
  end

  private

  def set_profile
    @profile = current_user.master_profile
  end

  def set_item
    @item = @profile.portfolio_items.find(params[:id])
  end

  def item_params
    params.require(:portfolio_item).permit(:image, :title, :description)
  end
end
