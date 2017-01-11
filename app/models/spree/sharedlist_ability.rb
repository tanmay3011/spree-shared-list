class Spree::SharedlistAbility
  include CanCan::Ability

  def initialize(user)
    self.clear_aliased_actions

    alias_action :delete, to: :destroy
    alias_action :edit, to: :update
    alias_action :new, to: :create
    alias_action :show, to: :read
    alias_action :index, :read, to: :display
    alias_action :create, :update, :destroy, to: :modify

    user ||= Spree.user_class.new

    if user.respond_to?(:has_spree_role?) && user.has_spree_role?('admin')
      can :manage, :all
    else
      can :modify, Sharedlist, user_id: user.id
      can :display, Sharedlist
    end

  end

end

Spree::Ability.register_ability(Spree::SharedlistAbility)
