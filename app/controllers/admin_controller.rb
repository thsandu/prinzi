class AdminController < ApplicationController
  before_action :check_admin

  def index
    @verfugbarkeiten_anzahl = Verfugbarkeit.count
    @user_anzahl = User.count

    @wochen_auslastung
    User.where(typ: "Mitarbeiter").order(:username).each do |user|
      verfugbarkeiten = user.berechne_verf_am_tag(Time.mktime(2018, 8, 23), Time.mktime(2018, 8, 24))
      @wochen_auslastung = {user.username => verfugbarkeiten.map{ |v| v.start}}

      puts "wochen_auslastung: #{@wochen_auslastung}"
    end
  end

  def zeige_verf_kw(kalender_woche, user)
    Verfugbarkeit.where({user_id: user.id})
  end

  protected
  def check_admin
  end

end
