class Verfugbarkeit < ApplicationRecord
  has_many :buchungs, dependent: :destroy

  def erzeuge_buchung_frei(start_zeit, ende_zeit)
    if(buchung_moeglich?(start_zeit, ende_zeit)) then
      buchung = Buchung.new
      buchung.befreie_zeitraum(start_zeit, ende_zeit)
      self.buchungs.push(buchung)
    end
    buchung.save!
  end

  def erzeuge_buchung_besetzt(start_zeit, ende_zeit)
    if(buchung_moeglich?(start_zeit, ende_zeit)) then
      buchung = Buchung.new
      buchung.besetze_zeitraum(start_zeit, ende_zeit)
      self.buchungs.push(buchung)
    end
    buchung.save!
  end

  def erzeuge_buchung_gebucht(start_zeit, ende_zeit)
    if(buchung_moeglich?(start_zeit, ende_zeit)) then
      buchung = Buchung.new
      buchung.buche_zeitraum(start_zeit, ende_zeit)
      self.buchungs.push(buchung)
    end
    buchung.save!
  end

  def buchung_moeglich?(start_zeit, ende_zeit)
    self.buchungs.each do |buchung|
      if buchung.ueberschneidet_sich?(start_zeit, ende_zeit)
        puts "Buchung zu dem Zeitpunkt #{start_zeit} - #{ende_zeit} bereits existent"
        resolve_buchungen!(buchung, start_zeit, ende_zeit)
        buchung.save!
      end
    end
    true
  end

  private

  def buchung_kuerzen!(buchung, start_zeit, ende_zeit)
    if(start_zeit.between?(buchung.start, buchung.ende)) then
      puts "Kuerze Buchung mit ende #{buchung.ende}"
      buchung.kuerze_buchung_vom_ende(buchung.ende - start_zeit + 60)
    end

    if (ende_zeit.between?(buchung.start, buchung.ende)) then
      puts "Kuerze Buchung vom start #{buchung.start}"
      buchung.kuerze_buchung_vom_start(ende_zeit - buchung.start + 60)
    end
    buchung
  end

  private

  def resolve_buchungen!(exist_buchung, start_neu, ende_neu)
    case exist_buchung.compute_uberschneidung(start_neu, ende_neu)
    when :keine
      #exception
    when :ende
      exist_buchung.kuerze_buchung_vom_start(ende_neu - exist_buchung.start + 60)
    when :start
      exist_buchung.kuerze_buchung_vom_ende(exist_buchung.ende - start_neu + 60)
    when :enthalten
    end

  end


end
