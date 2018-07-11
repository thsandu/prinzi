class PrinziCalController < ApplicationController
  def index
    @verfugbarkeits = Verfugbarkeit.all
  end
end
