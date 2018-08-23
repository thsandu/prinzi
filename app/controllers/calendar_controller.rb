require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

SCOPE = 'https://www.googleapis.com/auth/calendar'
CALENDAR_ID = 'v0snmr43tpv6tlnpknn46g72tc@group.calendar.google.com'

class CalendarController < ApplicationController
  before_action :set_verfugbarkeits, only: [:new_buchung]

  # Starting action in config/routes.rb
  def index
    @client_id = Rails.application.secrets.google_client_id
    @client_secret = Rails.application.secrets.google_client_secret
    @calendar_id = CALENDAR_ID
  end

  #POST calendar/authorize
  def authorize
    client = Signet::OAuth2::Client.new(client_options(params[:client_id], params[:client_secret]))
    session[:client_id] = params[:client_id]
    session[:client_secret] = params[:client_secret]
    session[:calendar_id] = params[:calendar_id]
    redirect_to client.authorization_uri.to_s
  end

  #POST calendar/disconnect
  def disconnect
    puts "logout started"

    reset_session
  end

  # GET /calendar/new_buchung
  def new_buchung
    @verfugbarkeit = Verfugbarkeit.new
  end

  # POST /calendar/buchungs
  def create

    verf_params = succ_param[:verfugbarkeit]
    logger.debug "Start hoho datum: #{verf_params['start(1i)']}"

    jahr = verf_params['start(1i)']
    monat = verf_params['start(2i)']
    tag = verf_params['start(3i)']

    @verfugbarkeit = Verfugbarkeit.new(succ_param[:verfugbarkeit])

    @@service = init_event_service

    event = Google::Apis::CalendarV3::Event.new(
      summary: "Dto Event: #{@verfugbarkeit.status}",
      description: "Prinzi: Ich bin FREI",
      transparency: "transparent",
      start: {
        date_time: @verfugbarkeit.start.strftime("%Y-%m-%dT%H:%M:%S"),
        time_zone: 'Europe/Bucharest'
      },
      end: {
        date_time: @verfugbarkeit.ende.strftime("%Y-%m-%dT%H:%M:%S"),
        time_zone: 'Europe/Bucharest'
      }
    )

    result = @@service.insert_event(session[:calendar_id], event)
    puts "Event created: #{result.html_link}"

    @verfugbarkeit.gcal_id = result.id

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

  # PATCH/PUT /calendar/buchungs/1
  # PATCH/PUT /calendar/buchungs/1.json
  def update_buchung

    @@service = init_event_service

    respond_to do |format|
      if @buchung.update(verf_params)
        format.html { redirect_to @buchung, notice: 'Buchung was successfully updated.' }
        format.json { render :show, status: :ok, location: @buchung }
      else
        format.html { render :edit }
        format.json { render json: @buchung.errors, status: :unprocessable_entity }
      end
    end
  end

  def success
    logger.debug "request is set? #{request}"

    client = Signet::OAuth2::Client.new(client_options(session[:client_id], session[:client_secret]))
    client.code = succ_param[:code]

    response = client.fetch_access_token!

    session[:authorization] = response

    redirect_to calendar_list_events_url

    # url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)

    # redirect_to calendar_list_events_url
  end

  def list_events
    # falls der service nicht mehr initialisiert ist, geh zurück zu index und initialisiere
    @@service = init_event_service

    @calendar_id = session[:calendar_id]
    event_response = @@service.list_events(@calendar_id,
                                           max_results: 10,
                                           single_events: true,
                                           order_by: 'startTime',
                                           time_min: Time.now.iso8601)
    events_cal = event_response.items
    event_cald_ids = events_cal.map { |e| e.id }
    logger.debug "event calendar IDs gefunden: #{event_cald_ids}"
    verfugbarkeit_with_gid = Verfugbarkeit.where({ gcal_id: [event_cald_ids]})

    logger.debug "next_events sind: #{verfugbarkeit_with_gid}, size #{verfugbarkeit_with_gid.size}"

    @next_events = verfugbarkeit_with_gid.to_a
  end

  private

  def client_options (client_id, client_secret)
    {
      client_id: client_id,
      client_secret: client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: SCOPE,
      redirect_uri: 'http://localhost:3000/calendar/success'
    }
  end

  def init_event_service
    client = Signet::OAuth2::Client.new(client_options(session[:client_id], session[:client_secret]))
    client.update!(session[:authorization])

    @@service = Google::Apis::CalendarV3::CalendarService.new
    @@service.authorization = client
    @@service
  end

  def succ_param
    #params.require(:buchung).permit!
    #params
    params.permit(:code, :events_response, :authenticity_token, :status, :start, :ende, :verfugbarkeit_id, :client_id, :client_secret, :calendar_id, verfugbarkeit: {})
  end

  def set_verfugbarkeits
    @verfugbarkeits = Verfugbarkeit.all
  end

end
