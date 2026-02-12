class Customers::EstimatesController < ApplicationController
  include CustomerAccessible

  def show
    @estimate = Estimate.joins(:request).where(requests: { customer_id: current_user.id }).find(params[:id])
    authorize @estimate
  end
end
