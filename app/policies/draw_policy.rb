class DrawPolicy < ApplicationPolicy
  def index?
    user.draws.include? record
  end

  def create?
    true
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def draw?
    admin? && record.draw_items.present?
  end

  def admin?
    user.admin_draws.include? record
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
