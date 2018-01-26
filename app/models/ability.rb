class Ability
  include CanCan::Ability

  def initialize(user)
    # initialize user as anonymous user if not logged in
    anonymous = user.nil?
    user ||= User.new

    unless anonymous

      if user.super_admin?
        can :manage, [Site, Station, Contract, User, Access]
        can :read, [RoadOrder]
      else
        can :read, Site, :id => user.site_id
        
        user_contracts = user.contracts.pluck(:id)
        
        # non super admins can only read contracts, stations, and road orders they have access to
        can :read, Contract, :id => user_contracts
        can :read, Station, :contract_id => user_contracts
        can :read, RoadOrder, :contract_id => user_contracts
        can :read, BackOrder, :contract_id => user_contracts
        
        # method engineers can also create road orders for their contracts
        can :create, RoadOrder, :contract_id => user_contracts if user.method_engineer?
         
        # planners can also create back orders for their contracts
        can :create, BackOrder, :contract_id => user_contracts if user.planner?

        if user.admin?
          admin_accessible_roles = [ "admin", "supervisor", "planner", "method_engineer", "quality", "station" ]
          can :manage, User, :site_id => user.site_id, :role => admin_accessible_roles
          can :manage, Access, user: { site_id: user.site_id, role: admin_accessible_roles }
        end
      end
      
      # a user can manage their own uploads
      can :manage, Upload, user_id: user.id 
    end
  end
end
