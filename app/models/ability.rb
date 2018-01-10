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
          # non super admins can only read contracts and stations they have access to
          can :read, Contract, :id => access.contract_id
          can :read, Station, :contract_id => access.contract_id

          # method engineers can manage, all other users can only read
          can user.method_engineer? ? :manage : :read, RoadOrder, :contract_id => access.contract_id          
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
      
      # a user can manage their own uploads
      can :manage, Upload, user_id: user.id 
    end
  end
end
