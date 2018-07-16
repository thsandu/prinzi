module PrinziCalHelper

  def format_date_to_hh_mm(timestamp)
    timestamp.strftime("%H:%M")
  end

end
