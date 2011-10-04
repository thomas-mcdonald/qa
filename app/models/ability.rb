class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    @user ||= User.new
    #
    # Posts
    #
    can :read, Question do |q|
      true unless q.deleted? && logged_in? && @user.reputation < 1000
    end
    can :create, Question
    can :update, Question do |q|
      f = false
      next unless logged_in?
      f = true if @user.moderator?
      f = true if q.user_id == @user.id
      f = true if @user.reputation > 500
      f
    end
    #
    # Votes
    #
    can :create, Vote do |vote|
      f = false
      next unless logged_in?
      f = true if vote.value == 1 && @user.can_upvote?
      f = true if vote.value == -1 && @user.can_downvote?
      f
    end
  end

  def logged_in?
    !!@user.id
  end
end
