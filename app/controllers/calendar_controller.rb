require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

SCOPE = 'https://www.googleapis.com/auth/calendar'
CLIENT_SECRETS_NAME = 'client_secrets.json'

class GoogleCalendar
  # Attributes Accessors (attr_writer + attr_reader)
  attr_accessor :auth_uri, :auth_client

  def initialize(forward)

    # ENV: Development
    # Google's API Credentials are in ~/config/client_secret.json
    client_secrets = Google::APIClient::ClientSecrets.load( File.join( Rails.root, 'config', 'client_secrets.json' ) )

    @auth_client = client_secrets.to_authorization

    puts "client secrets: #{@auth_client}. clientID: #{@auth_client.client_id}"
    # Specify privileges and callback URL
    @auth_client.update!(
      :scope => SCOPE,
      :redirect_uri => 'http://localhost:3000/calendar/success'
    )

    # Build up the Redirecting URL, nur wenn nötig
    @auth_uri = @auth_client.authorization_uri.to_s if forward

  end

end

class CalendarController < ApplicationController
  before_action :set_verfugbarkeits, only: [:new_buchung]

  # Starting action in config/routes.rb
  def index

    # Redirect to Google Authorization Page
    cal_api = GoogleCalendar.new(true)
    redirect_to cal_api.auth_uri

  end

  # GET /calendar/new_buchung
  def new_buchung
    @buchung = Buchung.new
  end

  def success
    cal_api = GoogleCalendar.new(false)
    cal_api.auth_client.code = succ_param[:code]
    cal_api.auth_client.fetch_access_token!

    @@service = Google::Apis::CalendarV3::CalendarService.new
    @@service.authorization = cal_api.auth_client

    redirect_to calendar_list_events_url
  end

  def list_events
    # falls der service nicht mehr initialisiert ist, geh zurück zu index und initialisiere
    if defined?(@@service).nil? then
      redirect_to calendar_url
      return
    end

    event_response = @@service.list_events('v0snmr43tpv6tlnpknn46g72tc@group.calendar.google.com',
                                           max_results: 10,
                                           single_events: true,
                                           order_by: 'startTime',
                                           time_min: Time.now.iso8601)
    @next_events = event_response.items
  end

  # def token
  #   # Get a auth_client object from Google API
  #   @google_api = GoogleCalendar.new

  #   @google_api.auth_client.code = params[:code] if params[:code]
  #   response = @google_api.auth_client.fetch_access_token!

  #   session[:access_token] = response['access_token']

  #   # Whichever Controller/Action needed to handle what comes next
  #   redirect_to prinzi_cal_index
  # end
  private

  def succ_param
    params.permit(:code, :events_response)
  end

  def set_verfugbarkeits
    @verfugbarkeits = Verfugbarkeit.all
  end

end
