class PrinziCalController < ApplicationController
  config.time_zone = 'Europe/Bucharest'
  def index
    verfugbarkeit_with_gid = Verfugbarkeit.where user_id: session[:user_id]

    logger.debug "next_events sind: #{verfugbarkeit_with_gid}, size #{verfugbarkeit_with_gid.size}"

    @verfugbarkeits = verfugbarkeit_with_gid.to_a
  end

  # GET /prinzi_cal/new_buchung
  def new_buchung
    @verfugbarkeit = Verfugbarkeit.new
  end

  # POST /prinzi_cal/buchungs
  def create
    verf_params = params[:verfugbarkeit]
    logger.debug "Start hoho datum: #{verf_params['start(1i)']}"

    jahr = verf_params['start(1i)']
    monat = verf_params['start(2i)']
    tag = verf_params['start(3i)']

    @verfugbarkeit = Verfugbarkeit.new(succ_param[:verfugbarkeit])
    @verfugbarkeit.user_id = session[:user_id]

    respond_to do |format|
      if @verfugbarkeit.save
        format.html { redirect_to @verfugbarkeit, notice: 'Verfügbarkeit was successfully created with cal controller. Link: #{result.html_link}' }
        format.json { render :show, status: :created, location: @verfugbarkeit }
      else
        format.html { render :new }
        format.json { render json: @verfugbarkeits.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def succ_param
    #params.require(:buchung).permit!
    #params
    params.permit(verfugbarkeit: {})
  end

end
