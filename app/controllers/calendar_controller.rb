require 'google/api_client/client_secrets'
require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'

SCOPE = 'https://www.googleapis.com/auth/calendar'
CLIENT_SECRETS_NAME = 'client_secrets.json'

class GoogleCalendar
  # Attributes Accessors (attr_writer + attr_reader)
  attr_accessor :auth_uri

  def initialize

    # ENV: Development
    # Google's API Credentials are in ~/config/client_secret.json
    client_secrets = Google::APIClient::ClientSecrets.load( File.join( Rails.root, 'config', 'client_secrets.json' ) )

    auth_client = client_secrets.to_authorization

    puts "client secrets: #{auth_client}. clientID: #{auth_client.client_id}"
    # Specify privileges and callback URL
    auth_client.update!(
      :scope => SCOPE,
      :redirect_uri => 'http://localhost:3000/calendar/success'
    )

    # Build up the Redirecting URL
    @auth_uri = auth_client.authorization_uri.to_s

  end

end

class CalendarController < ApplicationController

  # Starting action in config/routes.rb
  def index

    # Redirect to Google Authorization Page
    @cal_api = GoogleCalendar.new
    puts "auth client initialized? #{@cal_api.auth_uri}"
    redirect_to @cal_api.auth_uri

  end

  def success
    token_store = Google::Auth::Stores::FileTokenStore.new(file: File.join( Rails.root, 'config', CLIENT_SECRETS_NAME ))
    client_id = Google::Auth::ClientId.from_file(File.join( Rails.root, 'config', CLIENT_SECRETS_NAME ))
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)

    credentials = authorizer.get_credentials_from_code(user_id: 'default', code: params[:code], base_url: 'http://localhost:3000/calendar/success')
    puts "credentials SUCCESS: #{credentials}"

    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.authorization = credentials
    @next_events = @service.list_events('v0snmr43tpv6tlnpknn46g72tc@group.calendar.google.com',
                                        max_results: 10,
                                        single_events: true,
                                        order_by: 'startTime',
                                        time_min: Time.now.iso8601)
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

end
