class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    @user ||= User.new
    #
    # Questions
    #
    can :read, Question do |q|
      f = true
      f = false if q.deleted?
      f = true if @user.moderator?
      f
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
    can [:destroy, :restore], Question do |q|
      f = false
      next unless logged_in?
      f = true if @user.moderator?
      f
    end
    #
    # Answers
    #
    can :create, Answer
    can :update, Answer do |a|
      f = false
      next unless logged_in?
      f = true if @user.moderator?
      f = true if a.user_id = @user.id
      f = true if @user.reputation > 500
      f
    end
    can [:destroy, :restore], Answer do |a|
      f = false
      next unless logged_in?
      f = true if @user.moderator?
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
