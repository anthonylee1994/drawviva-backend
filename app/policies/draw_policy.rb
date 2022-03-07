class DrawPolicy < ApplicationPolicy
  def index?
    user.draws.include? record
  end

  def create?
    true
  end

  def update?
    user.admin_draws.include? record
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
