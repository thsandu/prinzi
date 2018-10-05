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

    ende_der_woche = @wochen_datums.last
    verfugbarkeit_with_gid = Verfugbarkeit.where(user_id: session[:user_id], start: @wochen_datums.first..Time.mktime(ende_der_woche.year, ende_der_woche.month, ende_der_woche.day, 23, 59))

    logger.debug "next_events sind: #{verfugbarkeit_with_gid}, size #{verfugbarkeit_with_gid.size}"

    @verfugbarkeits = verfugbarkeit_with_gid.order(:start).to_a
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
    stunde = verf_params['start(4i)']
    minuten = nil
    ende = verf_params['ende']

    @verfugbarkeit = Verfugbarkeit.new(succ_param[:verfugbarkeit])

    start = verf_params[:start]
    # Fall für Anlage von Verfügbarkeiten ohne Angabe des genauen Ende Datums
    if(start.nil?) then
      start = Time.mktime(jahr, monat, tag, stunde, minuten)
    else
      start = Time.parse(start)
    end

    ende_verf = Time.mktime(start.year, start.month, start.day, ende)
    @verfugbarkeit.start = start
    @verfugbarkeit.ende = ende_verf

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

  # DELETE /prinzi_cal/destroy
  def destroy

    logger.debug "Destroy verf_ids: #{succ_param[:verf_id]}, woche ist: #{succ_param[:woche]}"
    verf_to_delete = Verfugbarkeit.where(id: succ_param[:verf_id])

    verf_to_delete.each {|verf| verf.destroy}

    redirect_to contoller: 'prinzi_cal', action: 'index', woche: succ_param[:woche], notice: "#{verf_to_delete.size} Verfügbarkeiten gelöscht."
  end

  private
  def succ_param
    #params.require(:buchung).permit!
    #params
    params.permit(:woche, verf_id: [], verfugbarkeit: {})
  end

  def finde_verf_der_woche(kw, user)

  end

end
