class Ability
  include CanCan::Ability

  def initialize(employee)
    if employee.admin?
      can :manage, :all
    else
      can :read, :all
    end
  end
end
