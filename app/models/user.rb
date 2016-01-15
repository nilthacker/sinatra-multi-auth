class User < ActiveRecord::Base

  validates :email, presence: true, uniqueness: true
  has_many :auths

  after_initialize :set_default_values

  def set_default_values
    self.avatar_url ||= 'http://api.adorable.io/avatars/225/' + self.email
  end

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
