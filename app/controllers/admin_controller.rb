class AdminController < ApplicationController
  include DatumHelper
  before_action :check_admin

  def index
    logger.debug "woche in index: #{admin_params[:woche]} params: #{params}"
    @kal_woche = Time.now.to_date.cweek
    @kal_woche = admin_params[:woche] unless admin_params[:woche].nil?

    buch_start = session[:buchungs_start]
    buch_ende = session[:buchungs_ende]

    logger.debug "buchung start: #{buch_start}, buch_ende: #{buch_ende}"

    @verfugbarkeiten_anzahl = Verfugbarkeit.count
    @user_anzahl = User.count
    @wochen_auslastung = {}
    @wochen_datums = finde_mo_bis_so_datum(@kal_woche)
    @alle_user = User.where(typ: :Mitarbeiter).order(:username)

    @alle_user.each do |user|
      @wochen_auslastung[user] = []
      @wochen_datums.each do |day|
        morgen = Time.mktime(day.year, day.month, day.day)
        nacht = Time.mktime(day.year, day.month, day.day, 23, 59)

        verfugbarkeiten = user.berechne_verf_am_tag(morgen, nacht, buch_start, buch_ende)
        @wochen_auslastung[user].push verfugbarkeiten
      end
    end

    logger.debug "Wochenauslastung: #{@wochen_auslastung[@alle_user.first]}"

  end

  # get admin/zeige_moeg
  def zeige_moeglichkeiten
    buchungs_anfrage = admin_params[:buchungs_anfrage]
    buchungs_start_datum = buchungs_anfrage[:startdatum]
    buchungs_start_stunde = admin_params[:date]
    buchungs_dauer = buchungs_anfrage[:dauer]
    buchungs_anfang = Time.mktime(buchungs_start_datum[:year], buchungs_start_datum[:month], buchungs_start_datum[:day], buchungs_start_stunde[:hour])
    buchungs_ende = Time.mktime(buchungs_start_datum[:year], buchungs_start_datum[:month], buchungs_start_datum[:day], buchungs_start_stunde[:hour].to_i + buchungs_dauer.to_i)

    session[:buchungs_start] = buchungs_anfang
    session[:buchungs_ende] = buchungs_ende
    logger.debug "woche in zeige: #{admin_params[:woche]} params: #{params}"
    redirect_to admin_url(woche: admin_params[:woche]), action: "get", notice: "Frei zwischen #{buchungs_anfang} und #{buchungs_ende}? Ich sehe GELB"
  end

  def admin_params
    params.permit!
    #params.permit(:woche, :buchungs_start, :buchungs_ende, :buchungs_anfrage => {})
  end

  protected
  def check_admin
  end

end
