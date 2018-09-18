require 'date'

module AdminHelper

  def week_dates( week_num )
    woche = week_num.to_i
    year = Time.now.year
    week_start = Date.commercial( year, woche, 1 )
    week_end = Date.commercial( year, woche, 7 )
    week_start.strftime( "%m/%d/%y" ) + ' - ' + week_end.strftime(
    "%m/%d/%y" )
  end
end
