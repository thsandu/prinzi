class Buchung < ApplicationRecord
  belongs_to :verfugbarkeit


  # besetzt = mitarbeiter hat da keine Zeit
  # frei = mitarbeiter hat zeit, kann gebucht werden
  # gebucht = mitarbeiter wurde fest gebucht

  def besetze_zeitraum(start_zeit, ende_zeit)
    self.status = 'besetzt'
    self.start = start_zeit
    self.ende = ende_zeit
  end

  def befreie_zeitraum(start_zeit, ende_zeit)
    self.status = 'frei'
    self.start = start_zeit
    self.ende = ende_zeit
  end

  def buche_zeitraum(start_zeit, ende_zeit)
    self.status = 'gebucht'
    self.start = start_zeit
    self.ende = ende_zeit
  end

  def kuerze_buchung_vom_start(kuerzung_sekunden)
    self.start = self.start + kuerzung_sekunden
  end

  def kuerze_buchung_vom_ende(kuerzung_sekunden)
    self.ende = self.ende - kuerzung_sekunden
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

  def compute_uberschneidung(start_zeit, ende_zeit)
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
end
