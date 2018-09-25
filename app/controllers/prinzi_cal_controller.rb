class PrinziCalController < ApplicationController
  include DatumHelper

  def index

    @kal_woche = Time.now.to_date.cweek
    @kal_woche = succ_param[:woche] unless succ_param[:woche].nil?
    @wochen_datums = finde_mo_bis_so_datum(@kal_woche)
    @wochen_auslastung = {}

    user = User.find session[:user_id]

    @wochen_auslastung[user] = []
    @wochen_datums.each do |day|
      morgen = Time.mktime(day.year, day.month, day.day)
      nacht = Time.mktime(day.year, day.month, day.day, 23, 59)

      verfugbarkeiten = user.berechne_verf_am_tag(morgen, nacht)
      @wochen_auslastung[user].push verfugbarkeiten
    end

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
    params.permit(:woche, verfugbarkeit: {})
  end

end
