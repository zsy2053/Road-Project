class Ability
  include CanCan::Ability

  def initialize(user)
    # initialize user as anonymous user if not logged in
    anonymous = user.nil?
    user ||= User.new

    unless anonymous

      admin_accessible_roles = [ "admin", "supervisor", "planner", "method_engineer", "quality", "station" ]

      if user.super_admin?
        can :manage, [Site, Station, Contract, User, Access, Operator]
        can :read, [RoadOrder, CarRoadOrder, TransferOrder, BackOrder, Movement]
      elsif user.api_trackware?
        can :manage, TransferOrder
      else
        can :read, Site, :id => user.site_id
        user_contracts = user.contracts.pluck(:id)

        # non super admins can only read contracts, stations, road orders, and back orders they have access to
        can :read, Contract, :id => user_contracts
        can :read, Station, :contract_id => user_contracts
        can :read, RoadOrder, :contract_id => user_contracts
        can :read, CarRoadOrder, road_order: { :contract_id => user_contracts }
        can :read, BackOrder, :contract_id => user_contracts
        can :read, User, contracts: { :id => user_contracts }, :role => admin_accessible_roles
        can :read, Movement, road_order: { :contract_id => user_contracts }
        can :read, Position, car_road_order: { road_order: { :contract_id => user_contracts } }
        # method engineers can also create road orders for their contracts
        can :create, RoadOrder, :contract_id => user_contracts if user.method_engineer?

        # supervisors can also create car road orders for their contracts
        can :create, CarRoadOrder, road_order: { :contract_id => user_contracts } if user.supervisor?

        # planners can also create back orders for their contracts
        can :create, BackOrder, :contract_id => user_contracts if user.planner?

        if user.admin?
          can :manage, User, :site_id => user.site_id, :role => admin_accessible_roles
          can :manage, Operator, :site_id => user.site_id
          can :manage, Station, :contract_id => user_contracts
          can :manage, Access, :contract_id => user_contracts, user: { site_id: user.site_id, role: admin_accessible_roles }
        end

        if user.supervisor?
          can :manage, Operator, :site_id => user.site_id
          can :update, Position, car_road_order: { road_order: { :contract_id => user_contracts } }
          can :update, Movement, road_order: { :contract_id => user_contracts }
          can :read, TransferOrder, :contract_id => user_contracts
        end

        can :update, Movement, road_order: { :contract_id => user_contracts } if user.quality?
        if user.quality? or user.station?
          can :read, Operator, :site_id => user.site_id
          can :read, TransferOrder, :contract_id => user_contracts
        end
      end

      # a user can manage their own uploads
      can :manage, Upload, user_id: user.id
    end
  end
end
