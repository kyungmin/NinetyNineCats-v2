require 'bcrypt'

class User < ActiveRecord::Base
#  include Bcrypt

  attr_accessible :user_name, :password
  validates :user_name, :password_digest, :session_token, presence: true
  validates :user_name, uniqueness: true
  before_validation :require_token

  has_many(
    :cats,
    :class_name => 'Cat',
    :primary_key => :id,
    :foreign_key => :user_id
  )

  def password=(password)
    self.password_digest = BCrypt::Password.create(password).to_s
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)

    user.is_password?(password) ? user : nil
  end

  def reset_session_token!(force = true)
    return unless self.session_token.nil? || force

    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
  end

  def is_owner?(cat)
    self.id == cat.owner.id
  end

  private

  def require_token
    self.session_token ||= self.session_token = SecureRandom.urlsafe_base64(16)
  end
end
