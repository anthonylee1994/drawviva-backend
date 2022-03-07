class UserDrawPolicy < ApplicationPolicy
  def create?
    admin?
  end

  def destroy?
    admin? || record.user == user
  end

  def admin?
    user.admin_draws.include? record.draw
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
