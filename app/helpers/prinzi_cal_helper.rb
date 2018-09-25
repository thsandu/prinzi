module PrinziCalHelper

  def format_date_to_hh_mm(timestamp)
    timestamp.strftime("%H:%M")
  end

  def bestimme_verf_anzeige(stunde, verfugbarkeiten)
    verfugbarkeiten[:verfügbar].each do |verf_zeit|
      return 'V' if ist_stunde_zwischen?(stunde, verf_zeit)
    end
    verfugbarkeiten[:abwesend].each do |verf_zeit|
      return 'A' if ist_stunde_zwischen?(stunde, verf_zeit)
    end
    verfugbarkeiten[:fragen].each do |verf_zeit|
      return 'F' if ist_stunde_zwischen?(stunde, verf_zeit)
    end

  end

  def ist_stunde_zwischen?(stunde, verfugbarkeit)
    pattern_stunden = /(\d{1,2}) - (\d{1,2})/
    anfang = pattern_stunden.match(verfugbarkeit)[1]
    ende = pattern_stunden.match(verfugbarkeit)[2]

    range = (anfang.to_i..ende.to_i)
    zwischen = range.cover?(stunde.to_i)

    zwischen
  end

end
