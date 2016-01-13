class User < ActiveRecord::Base

  validates :email, presence: true, uniqueness: true
  has_many :auths

  def password
    @password ||= BCrypt::Password.new(password_hash)
  end

  def password=(new_password_plaintext)
    @password = BCrypt::Password.create(new_password_plaintext)
    self.password_hash = @password.to_s
  end

  def authenticate(password_plaintext)
    return self.password == password_plaintext
  end
end
