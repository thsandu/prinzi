class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  has_secure_password

  def is_admin?
    @typ == 'Administrator'
  end

  def berechne_verf_am_tag(start_date, end_date)
    verfugbarkeiten = Verfugbarkeit.where({user_id: self.id, start: start_date..end_date}).order(:start)
  end

end
