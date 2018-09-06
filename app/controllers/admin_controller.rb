class AdminController < ApplicationController
  before_action :check_admin

  def index
    @verfugbarkeiten_anzahl = Verfugbarkeit.count
    @user_anzahl = User.count
  end

  protected
  def check_admin
  end

end
