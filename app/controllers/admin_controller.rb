class AdminController < ApplicationController
  include DatumHelper
  before_action :check_admin

  def index
    @kal_woche = Time.now.to_date.cweek
    @kal_woche = admin_params[:woche] unless admin_params[:woche].nil?

    @verfugbarkeiten_anzahl = Verfugbarkeit.count
    @user_anzahl = User.count
    @wochen_auslastung = {}
    @wochen_datums = finde_mo_bis_so_datum(@kal_woche)
    @alle_user = User.where(typ: "Mitarbeiter").order(:username)

    @alle_user.each do |user|
      @wochen_auslastung[user] = []
      @wochen_datums.each do |day|
        morgen = Time.mktime(day.year, day.month, day.day)
        nacht = Time.mktime(day.year, day.month, day.day, 23, 59)
        buch_start = Time.mktime(day.year, day.month, day.day, 12)
        buch_ende = Time.mktime(day.year, day.month, day.day, 16)

        verfugbarkeiten = user.berechne_verf_am_tag(morgen, nacht, buch_start, buch_ende)
        @wochen_auslastung[user].push verfugbarkeiten
      end
    end

    logger.debug "Wochenauslastung: #{@wochen_auslastung[@alle_user.first]}"

  end

  # get admin/zeige_moeg
  def zeige_moeglichkeiten
    buchungs_anfrage = admin_params[:buchungs_anfrage]
    buchungs_datum = buchungs_anfrage[:datum]
    buchungs_start = buchungs_anfrage[:startzeit]
    buchungs_dauer = buchungs_anfrage[:dauer]
    buchungs_ende = Time.mktime(buchungs_start.year, buchungs_start.month, buchungs_start.day, buchungs_start.hour + buchungs_dauer)


  end

  def admin_params
    params.permit(:woche, buchungs_anfrage: [:datum, :startzeit, :dauer])
  end

  protected
  def check_admin
  end

end
