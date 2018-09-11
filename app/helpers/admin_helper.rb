require 'date'

module AdminHelper

  def week_dates( week_num )
    year = Time.now.year
    week_start = Date.commercial( year, week_num, 1 )
    week_end = Date.commercial( year, week_num, 7 )
    week_start.strftime( "%m/%d/%y" ) + ' - ' + week_end.strftime(
    "%m/%d/%y" )
  end

  def finde_mo_bis_so_datum (week_num)
    datums = []
    year = Time.now.year
    (1..7).each do |day|
      datums=+ Date.commercial(year, week_num, day)
    end
    datums
  end
end
