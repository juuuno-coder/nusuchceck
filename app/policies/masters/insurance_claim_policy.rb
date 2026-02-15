module Masters
  class InsuranceClaimPolicy < ApplicationPolicy
    def show?
      prepared_by_master? || user.admin?
    end

    def create?
      user.master?
    end

    def update?
      prepared_by_master? && record.draft?
    end

    def edit?
      update?
    end

    def send_to_customer?
      prepared_by_master? && record.may_send_to_customer?
    end

    def destroy?
      prepared_by_master? && record.draft?
    end

    class Scope < Scope
      def resolve
        if user.admin?
          scope.all
        elsif user.master?
          scope.where(prepared_by_master_id: user.id)
        else
          scope.none
        end
      end
    end

    private

    def prepared_by_master?
      record.prepared_by_master_id == user.id
    end
  end
end
