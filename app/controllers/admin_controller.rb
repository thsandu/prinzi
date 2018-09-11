class AdminController < ApplicationController
  before_action :check_admin

  def index
    @verfugbarkeiten_anzahl = Verfugbarkeit.count
    @user_anzahl = User.count
    @wochen_auslastung = {}
    @wochen_datums = finde_mo_bis_so_datum(Time.now.to_date.cweek)
    @alle_user = User.where(typ: "Mitarbeiter").order(:username)

    @alle_user.each do |user|
      verfugbarkeiten = user.berechne_verf_am_tag(Time.mktime(2018, 8, 23), Time.mktime(2018, 8, 24))
      @wochen_auslastung[user] = verfugbarkeiten
    end

    logger.debug "Wochenauslastung: #{@wochen_auslastung}"

  end

  def zeige_verf_kw(kalender_woche, user)
    Verfugbarkeit.where({user_id: user.id})
  end

  protected
  def check_admin
  end

  def finde_mo_bis_so_datum (week_num)
    datums = []
    year = Time.now.year
    (1..7).each do |day|
      datums.push Date.commercial(year, week_num, day)
    end
    datums
  end

end
