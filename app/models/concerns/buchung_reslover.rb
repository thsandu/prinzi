#buchung_resolver.rb
#Erledigt sich überschneidende Buchungen
module BuchungResolver
  extend ActiveSupport::Concern

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
