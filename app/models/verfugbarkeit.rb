class Verfugbarkeit < ApplicationRecord
  enum status: [:verfügbar, :abwesend, :fragen]

  #status:
  # abwesend = mitarbeiter hat da keine Zeit
  # verfügbar = mitarbeiter hat zeit, kann gebucht werden
  # fragen = mitarbeiter weiss nicht genau, frag mal nach

  def anlegbar?
    start_tag = Time.mktime(self.start.year, self.start.month, self.start.day, 0, 0)
    ende_tag = Time.mktime(self.start.year, self.start.month, self.start.day, 23, 59)
    verfugbarkeiten = Verfugbarkeit.where(user_id: self.user_id, start: start_tag..ende_tag)

    verfugbarkeiten.each do |verf|
      if self.ueberschneidet_sich?(verf.start, verf.ende) || verf.ueberschneidet_sich?(self.start, self.ende)
        logger.debug "Überschneidung von #{self.start} - #{self.ende} mit #{verf}: #{verf.start} - #{verf.ende}"
        return false
      end
    end
    true
  end

  def erzeuge_verfugbarkeit_frei(start_zeit, ende_zeit)
    if(buchung_moeglich?(start_zeit, ende_zeit)) then
      verfugbarkeit = Verfugbarkeit.new
      verfugbarkeit.befreie_zeitraum(start_zeit, ende_zeit)
    end
    verfugbarkeit.save!
    verfugbarkeit
  end

  def erzeuge_verfugbarkeit_besetzt(start_zeit, ende_zeit)
    if(buchung_moeglich?(start_zeit, ende_zeit)) then
      verfugbarkeit = Verfugbarkeit.new
      verfugbarkeit.besetze_zeitraum(start_zeit, ende_zeit)
    end
    verfugbarkeit.save!
    verfugbarkeit
  end

  def erzeuge_verfugbarkeit_gebucht(start_zeit, ende_zeit)
    if(buchung_moeglich?(start_zeit, ende_zeit)) then
      verfugbarkeit = Verfugbarkeit.new
      verfugbarkeit.buche_zeitraum(start_zeit, ende_zeit)
    end
    verfugbarkeit.save!
    verfugbarkeit
  end

  def buchung_moeglich?(start_zeit, ende_zeit)
    true
  end

  def besetze_zeitraum(start_zeit, ende_zeit)
    self.status = :abwesend
    self.start = start_zeit
    self.ende = ende_zeit
  end

  def befreie_zeitraum(start_zeit, ende_zeit)
    self.status = :verfügbar
    self.start = start_zeit
    self.ende = ende_zeit
  end

  def buche_zeitraum(start_zeit, ende_zeit)
    self.status = :fragen
    self.start = start_zeit
    self.ende = ende_zeit
  end

  def ==(other)
    status_eq = false
    start_eq = false
    ende_eq = false
    status_eq = (self.status == other.status) if other.respond_to?(:status)
    start_eq = (self.start == other.start) if other.respond_to?(:start)
    ende_eq = (self.ende == other.ende) if other.respond_to?(:ende)

    status_eq && start_eq && ende_eq
  end


  def ueberschneidet_sich?(start_zeit, ende_zeit)
    compute_uberschneidung(start_zeit, ende_zeit) != :keine
  end

  private

  def buchung_kuerzen!(verfugbarkeit, start_zeit, ende_zeit)
    if(start_zeit.between?(verfugbarkeit.start, verfugbarkeit.ende)) then
      puts "Kuerze Verfügbarkeit mit ende #{verfugbarkeit.ende}"
      verfugbarkeit.kuerze_verfugbarkeit_vom_ende(verfugbarkeit.ende - start_zeit + 60)
    end

    if (ende_zeit.between?(verfugbarkeit.start, verfugbarkeit.ende)) then
      puts "Kuerze Verfügbarkeit vom start #{verfugbarkeit.start}"
      verfugbarkeit.kuerze_verfugbarkeit_vom_start(ende_zeit - verfugbarkeit.start + 60)
    end
    verfugbarkeit
  end

  def kuerze_verfugbarkeit_vom_start(kuerzung_sekunden)
    self.start = self.start + kuerzung_sekunden
  end

  def kuerze_verfugbarkeit_vom_ende(kuerzung_sekunden)
    self.ende = self.ende - kuerzung_sekunden
  end

  def compute_uberschneidung(start_zeit, ende_zeit)
    start_zeit = start_zeit + 1
    ende_zeit = ende_zeit - 1
    #Buchungen überschneiden sich nicht
    result=:keine

    case
    when ende_zeit.between?(self.start, self.ende)
      #nur ende zeitpunkt ist in der Buchung enthalten
      result = :ende
    when start_zeit.between?(self.start, self.ende)
      #nur start zeitpunkt ist in der Buchung enthalten
      result = :start
    when ende_zeit.between?(self.start, self.ende) && start_zeit.between?(self.start, self.ende)
      #start und ende sind in der Buchung enthalten - also voll enthalten
      result = :enthalten
    end

    return result
  end

  def resolve_buchungen!(exist_buchung, start_neu, ende_neu)
    case exist_buchung.compute_uberschneidung(start_neu, ende_neu)
    when :keine
      #exception
    when :ende
      exist_buchung.kuerze_verfugbarkeit_vom_start(ende_neu - exist_buchung.start + 60)
    when :start
      exist_buchung.kuerze_verfugbarkeit_vom_ende(exist_buchung.ende - start_neu + 60)
    when :enthalten
    end

  end


end
