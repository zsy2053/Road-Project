class Ability
  include CanCan::Ability

  def initialize(user)
    # initialize user as anonymous user if not logged in
    anonymous = user.nil?
    user ||= User.new

    unless anonymous

      if user.super_admin?
        can :manage, [Site, Station, Contract, User, Access]
      end

      user.accesses.each do |access|
        can :read, Station do |station|
          station.contract == access.contract
        end

        can :read, Site do |site|
          site == user.site
        end

        can :read, Contract do |contract|
          contract == access.contract
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
