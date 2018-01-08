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
        can :read, Site do |site|
          site == user.site
        end

        user.accesses.each do |access|
          can :read, Contract do |contract|
            contract == access.contract
          end

          can :read, Station do |station|
            station.contract == access.contract
          end

          # method engineers can manage, all other users can only read
          can user.method_engineer? ? :manage : :read, RoadOrder, station: { contract: access.contract }
        end

        if user.admin?
          can :manage, User do |u|
            u.role != 'super_admin' and u.site == user.site
          end

          can :manage, Access do |a|
            a.user.role != 'super_admin' and a.user.site == user.site
          end
        end
      end
    end
  end
end
