class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    #
    # Posts
    #
    can :read, Question do |q|
      f = false
      f = true unless q.deleted? && user.reputation < 1000
      f
    end
    can :create, Question
    can :update, Question do |q|
      f = false
      f = true if q.user_id == user.id
      f = true if user.reputation > 500
      f
    end
    #
    # Votes
    #
    can :create, Vote do |vote|
      a = false
      a = true if vote.value == 1 && user.can_upvote?
      a = true if vote.value == -1 && user.can_downvote?
      a
    end
  end
end
