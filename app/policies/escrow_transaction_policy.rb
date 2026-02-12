class EscrowTransactionPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || record.customer_id == user.id || record.master_id == user.id
  end

  def release_payment?
    user.admin? && record.may_release?
  end

  def refund?
    user.admin? && record.may_refund?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.customer?
        scope.where(customer_id: user.id)
      elsif user.master?
        scope.where(master_id: user.id)
      else
        scope.none
      end
    end
  end
end
