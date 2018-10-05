module PrinziCalHelper

  def format_date_to_hh_mm(timestamp)
    timestamp.strftime("%H:%M")
  end

  def bestimme_verf_anzeige(stunde, verfugbarkeiten)
    anzeige = ''
    verfugbarkeiten[:verfügbar].each do |verf_zeit|
      anzeige = 'V' if ist_stunde_zwischen?(stunde, verf_zeit)
    end
    verfugbarkeiten[:abwesend].each do |verf_zeit|
      anzeige = 'A' if ist_stunde_zwischen?(stunde, verf_zeit)
    end
    verfugbarkeiten[:fragen].each do |verf_zeit|
      anzeige = 'F' if ist_stunde_zwischen?(stunde, verf_zeit)
    end
    anzeige
  end

  def ist_stunde_zwischen?(stunde, verfugbarkeit)
    pattern_stunden = /(\d{1,2}) - (\d{1,2})/
    anfang = pattern_stunden.match(verfugbarkeit)[1]
    ende = pattern_stunden.match(verfugbarkeit)[2]

    range = (anfang.to_i...ende.to_i)
    zwischen = range.cover?(stunde.to_i)

    zwischen
  end

  def bestimme_anzeige_format(anzeige)
    mapping = ''
    case anzeige
    when "A"
      mapping = "abwesend"
    when "V"
      mapping = "verfügbar"
    when "F"
      mapping = "fragen"
    end
    mapping
  end

end
