class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  has_secure_password

  def is_admin?
    @typ == 'Administrator'
  end

end
