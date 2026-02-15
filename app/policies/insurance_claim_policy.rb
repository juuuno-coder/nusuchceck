class InsuranceClaimPolicy < ApplicationPolicy
  def show?
    owner? || user.admin?
  end

  def create?
    user.customer?
  end

  def update?
    owner? && record.draft?
  end

  def edit?
    update?
  end

  def submit_claim?
    owner? && record.may_submit_claim?
  end

  def customer_approve?
    owner? && record.may_customer_approve?
  end

  def customer_request_changes?
    owner? && record.may_customer_request_changes?
  end

  def download_pdf?
    owner? || user.admin?
  end

  def start_review?
    user.admin?
  end

  def approve?
    user.admin?
  end

  def reject?
    user.admin?
  end

  def complete?
    user.admin?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      elsif user.customer?
        scope.where(customer_id: user.id)
      else
        scope.none
      end
    end
  end

  private

  def owner?
    record.customer_id == user.id
  end
end
