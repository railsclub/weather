require 'bundler/setup'
Bundler.setup
require 'sinatra/base'
require 'forecast_io'
require 'http'
require 'multi_json'

class Weather < Sinatra::Application
  ForecastIO.api_key = '26b419412a1e30f9b81c2ed4467417e5'

  get '/' do
    erb :index
  end

  post '/get_weather' do
    zipcode = params["zipcode"]
    redirect("/#{zipcode}")
  end

  get '/:zipcode' do
    url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{params[:zipcode]}&sensor=false"
    response = HTTP.get(url)
    data = MultiJson.load(response.body)['results'].first['geometry']['location']
    lat = data['lat']
    lng = data['lng']
    ###
    @current_temperature = nil
    forecast = ForecastIO.forecast(lat, lng)
    @current_temperature = forecast['currently']['temperature'].to_i
    erb :weather
  end
end
