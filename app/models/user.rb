class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  has_secure_password

  def is_admin?
    @typ == 'Administrator'
  end

  # hash mit verfügbarkeiten Intervallen.
  # Beispiel: auslastungen: {:verfügbar=>["9 - 11", "11 - 12"], :abwesend=>["12 - 18"], :fragen=>["18 - 19"]}
  def berechne_verf_am_tag(start_date, end_date)
    verfugbarkeiten = Verfugbarkeit.where({user_id: self.id, start: start_date..end_date}).order(:start)

    logger.info "berechnete verfügbarkeiten: #{verfugbarkeiten.to_a}"

    auslastungen = {verfügbar: [], abwesend: [], fragen: []}
    verfugbarkeiten.each do |verf|
      start_zeit = verf.start
      ende_zeit = verf.ende
      case verf.status
      when "verfügbar"
        auslastungen[:verfügbar].push "#{start_zeit.hour} - #{ende_zeit.hour}"
      when "abwesend"
        auslastungen[:abwesend].push "#{start_zeit.hour} - #{ende_zeit.hour}"
      when "fragen"
        auslastungen[:fragen].push "#{start_zeit.hour} - #{ende_zeit.hour}"
      end

    end
    auslastungen
  end

end
