class AdminController < ApplicationController
  include DatumHelper
  before_action :check_admin

  def index
    @kal_woche = Time.now.to_date.cweek
    @kal_woche = params[:woche] unless params[:woche].nil?

    @verfugbarkeiten_anzahl = Verfugbarkeit.count
    @user_anzahl = User.count
    @wochen_auslastung = {}
    @wochen_datums = finde_mo_bis_so_datum(@kal_woche)
    @alle_user = User.where(typ: "Mitarbeiter").order(:username)

    @alle_user.each do |user|
      @wochen_auslastung[user] = []
      @wochen_datums.each do |day|
        verfugbarkeiten = user.berechne_verf_am_tag(Time.mktime(day.year, day.month, day.day), Time.mktime(day.year, day.month, day.day, 23, 59))
        @wochen_auslastung[user].push verfugbarkeiten
      end
    end

    logger.debug "Wochenauslastung: #{@wochen_auslastung[@alle_user.first]}"

  end

  def admin_params
    #params.permit(:woche)
  end

  protected
  def check_admin
  end

end
