class Ability
  include CanCan::Ability

  def initialize(user)
    @user ||= User.new
    #
    # Posts
    #
    can :read, Question do |q|
      true unless q.deleted? && logged_in? && @user.reputation < 1000
    end
    can :create, Question
    can :update, Question do |q|
      false
      next unless logged_in?
      true if q.user_id == @user.id
      true if @user.reputation > 500
    end
    #
    # Votes
    #
    can :create, Vote do |vote|
      false
      next unless logged_in?
      true if vote.value == 1 && @user.can_upvote?
      true if vote.value == -1 && @user.can_downvote?
    end
  end

  def logged_in?
    !!@user.id
  end
end
