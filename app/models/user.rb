class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  has_secure_password

  def is_admin?
    puts "typ ist: #{@typ}"
    puts "result ist: #{@typ == 'Administrator'}"
    @typ == 'Administrator'
  end

end
