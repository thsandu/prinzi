module DatumHelper

  def finde_mo_bis_so_datum (week_num)
    woche = week_num.to_i
    datums = []
    year = Time.now.year
    (1..7).each do |day|
      datums.push Date.commercial(year, woche, day)
    end
    datums
  end

  def zeige_verf_kw(kalender_woche, user)
    Verfugbarkeit.where({user_id: user.id})
  end

end
