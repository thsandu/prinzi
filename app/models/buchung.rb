class Buchung < ApplicationRecord
  enum typ: [:silber, :gold, :deluxe, :premium, :privat, :veranstaltung]
  enum status: [:angefragt, :bestätigt, :reserviert]


  # besetzt = mitarbeiter hat da keine Zeit
  # frei = mitarbeiter hat zeit, kann gebucht werden
  # gebucht = mitarbeiter wurde fest gebucht


end
