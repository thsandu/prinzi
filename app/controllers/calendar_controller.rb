require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

SCOPE = 'https://www.googleapis.com/auth/calendar'
CLIENT_SECRETS_NAME = 'client_secrets.json'
CALENDAR_ID = 'v0snmr43tpv6tlnpknn46g72tc@group.calendar.google.com'
CLIENT_SECRETS_PATH = File.join( Rails.root, 'config', CLIENT_SECRETS_NAME )

class GoogleCalendar
  # Attributes Accessors (attr_writer + attr_reader)
  attr_accessor :authorizer, :auth_client

  def initialize

    # ENV: Development
    # Google's API Credentials are in ~/config/client_secret.json
    #client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    client_id = '893778344541-3jcm22uhmk3h959bcp0hv0ff2t15la65.apps.googleusercontent.com'
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CLIENT_SECRETS_PATH)
    @authorizer = Google::Auth::WebUserAuthorizer.new(client_id, SCOPE, token_store, 'http://localhost:3000/calendar/success')

    puts "client secrets: #{@authorizer}. clientID: #{client_id}"
    # Specify privileges and callback URL

  end

end

class CalendarController < ApplicationController
  before_action :set_verfugbarkeits, only: [:new_buchung]

  # Starting action in config/routes.rb
  def index
    logger.debug "request is set - index: #{request}"
    # Redirect to Google Authorization Page
    cal_api = GoogleCalendar.new

    user_id = 'default'
    credentials = cal_api.authorizer.get_credentials(user_id, request)
    redirect_to cal_api.authorizer.get_authorization_url(user_id: 'default', request: request) if credentials.nil?

  end

  # GET /calendar/new_buchung
  def new_buchung
    @buchung = Buchung.new
  end

  # POST /calendar/buchungs
  def create
    old_verfugbarkeit = Verfugbarkeit.find(succ_param[:verfugbarkeit_id])
    @buchung = old_verfugbarkeit.buchungs.new(succ_param[:buchung])

    @@service = init_event_service

    event = Google::Apis::CalendarV3::Event.new(
      summary: "Dto Event",
      description: "Prinzi: Ich bin FREI",
      transparency: "transparent",
      start: {
        date_time: @buchung.start.strftime("%Y-%m-%dT%H:%M:%S"),
        time_zone: 'Europe/Bucharest'
      },
      end: {
        date_time: @buchung.ende.strftime("%Y-%m-%dT%H:%M:%S"),
        time_zone: 'Europe/Bucharest'
      }
    )

    result = @@service.insert_event(CALENDAR_ID, event)
    puts "Event created: #{result.html_link}"

    respond_to do |format|
      if @buchung.save
        format.html { redirect_to @buchung, notice: 'Buchung was successfully created with cal controller. Link: #{result.html_link}' }
        format.json { render :show, status: :created, location: @buchung }
      else
        format.html { render :new }
        format.json { render json: @buchung.errors, status: :unprocessable_entity }
      end
    end
  end

  def success
    logger.debug "request is set? #{request}"
    url = Google::Auth::WebUserAuthorizer.handle_auth_callback_deferred(request)

    redirect_to calendar_list_events_url
  end

  def list_events
    # falls der service nicht mehr initialisiert ist, geh zurück zu index und initialisiere
    @@service = init_event_service

    event_response = @@service.list_events(CALENDAR_ID,
                                           max_results: 10,
                                           single_events: true,
                                           order_by: 'startTime',
                                           time_min: Time.now.iso8601)
    @next_events = event_response.items
  end

  private

  def init_event_service
    cal_api = GoogleCalendar.new

    @@service = Google::Apis::CalendarV3::CalendarService.new
    @@service.authorization = cal_api.authorization
    @@service
  end

  def succ_param
    #params.require(:buchung).permit!
    #params
    params.permit(:code, :events_response, :authenticity_token, :status, :start, :ende, :verfugbarkeit_id, buchung: {})
  end


  def set_verfugbarkeits
    @verfugbarkeits = Verfugbarkeit.all
  end

end
