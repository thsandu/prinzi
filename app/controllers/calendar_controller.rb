class CalendarController < ApplicationController
  # GET /
  def index
  end

  # GET /calendar/success
  def success

  end

  def login_params
    params.require(:calendar_id)
  end

end
