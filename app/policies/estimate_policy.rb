class EstimatePolicy < ApplicationPolicy
  def show?
    user.admin? || owner_customer? || owner_master?
  end

  def create?
    owner_master? && record.request.may_submit_estimate?
  end

  def update?
    owner_master? && record.pending?
  end

  def accept?
    owner_customer? && record.pending?
  end

  def reject?
    owner_customer? && record.pending?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.customer?
        scope.joins(:request).where(requests: { customer_id: user.id })
      elsif user.master?
        scope.where(master_id: user.id)
      else
        scope.none
      end
    end
  end

  private

  def owner_customer?
    record.request.customer_id == user.id
  end

  def owner_master?
    user.master? && record.master_id == user.id
  end
end
