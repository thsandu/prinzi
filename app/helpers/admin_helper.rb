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

  # array von intervallen ["11 - 13", "15 - 17"]
  def print_verfugbar_zeiten(verfugbar_zeiten)
    result = nil
    verfugbar_zeiten.each do |intervall|
      unless result.nil?
      then
        result.concat ", #{intervall}"
      else
        result = intervall
      end
    end
    result
  end

end
