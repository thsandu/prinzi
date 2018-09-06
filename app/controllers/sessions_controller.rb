class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      case user.typ
      when 'Administrator'
        session[:admin] = true
        redirect_to admin_url
      when 'Mitarbeiter'
        session[:admin] = false
        redirect_to prinzi_cal_index_url
      end
    else
      redirect_to login_url, alert: "Username/Password Kombination falsch für: #{params[:username]}"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:admin] = nil
    redirect_to login_url, alert: "Erfolgreich ausgeloggt."
  end
end
