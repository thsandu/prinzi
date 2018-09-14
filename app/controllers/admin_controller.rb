class AdminController < ApplicationController
  before_action :check_admin

  def index
    @verfugbarkeiten_anzahl = Verfugbarkeit.count
    @user_anzahl = User.count
    @wochen_auslastung = {}
    @wochen_datums = finde_mo_bis_so_datum(Time.now.to_date.cweek)
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
