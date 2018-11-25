require 'net/http'
require 'uri'
require 'json'
require 'dotenv'

module ConnectAPI
  def self.initialize
    Dotenv.load
  end

  def self.request(uri)
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{ENV['API_KEY']}"
    req["Accept"] = "application/vnd.api+json"
    return req
  end

  def self.request_player_data(playername)
    uri = URI.parse("https://api.pubg.com/shards/#{ENV['PLATFORM_REGION']}/players?filter[playerNames]=#{playername}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    http.request(self.request(uri)).body
  end

  def self.get_player_id(response)
    JSON.parse(response)["data"][0]["id"]
  end
end

ConnectAPI.initialize
response = ConnectAPI.request_player_data('G_kenkun')
puts ConnectAPI.get_player_id(response)