class PrinziCalController < ApplicationController
  config.time_zone = 'Europe/Bucharest'
  def index
    @verfugbarkeits = Verfugbarkeit.all
  end
end
