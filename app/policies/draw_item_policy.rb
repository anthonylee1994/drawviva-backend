class DrawItemPolicy < ApplicationPolicy
  def create?
    update?
  end

  def update?
    user.admin_draws.include? record.draw
  end

  def destroy?
    update?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
