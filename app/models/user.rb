class User < ActiveRecord::Base
  has_many :answers
  has_many :comments
  has_many :flags
  has_many :notifications
  has_many :questions
  has_many :reputation_events
  has_many :votes

  # new columns need to be added here to be writable through mass assignment
  attr_accessible :email, :password, :password_confirmation, :about_me, :twitter, :display_name

  attr_accessor :password
  before_save :prepare_password

  validates_presence_of :username
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true

  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_username(login) || find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  def reputation
    self.reputation_cache || 0
  end

  def refresh_reputation
    events = self.reputation_events.all
    counter = 0
    events.each do |event|
      counter += ReputationEvent::REPUTATION_VALUES[event.value-1][:value]
    end
    self.reputation_cache = counter
    self.save
    self
  end

  def notify(token, parameters)
    self.notifications.create(
      :token => token,
      :parameters => parameters
    )
  end

  def active_notifications
    self.notifications.active
  end

  def moderator?
    role == 'moderator'  
  end

  def name
    display_name || username
  end

  def can_downvote?
    true if self.reputation > PERMISSIONS['can_downvote']
  end

  def can_upvote?
    true if self.reputation > PERMISSIONS['can_upvote']
  end

  def can_delete_items?
    true if self.reputation > PERMISSIONS['can_delete_items'] or self.moderator?
  end

  def can_view_deleted_items?
    true if self.reputation > PERMISSIONS['can_view_deleted_items'] or self.moderator?
  end

  def gravatar(size = 32)
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=#{size}"
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end
end
