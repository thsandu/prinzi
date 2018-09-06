class ApplicationController < ActionController::Base
  before_action :authorize

  protected
  def authorize
    usr_id = session[:user_id]
    unless usr_id && User.where(id: usr_id)
      redirect_to login_url, notice: "Seite ist nur erreichbar für eingeloggte User!"
    else
      @user = User.find(session[:user_id]) unless @user
    end


  end

end
