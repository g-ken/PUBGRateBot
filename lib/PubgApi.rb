Dotenv.load
API_KEY = ENV['API_KEY']
PLATFORM_REGION = ENV['PLATFORM_REGION']
MODES= ["solo", "solo-fpp", "duo", "duo-fpp", "squad", "squad-fpp"]

class PubgApi
  def self.search_player_id(player_name)
    uri = URI.parse("https://api.pubg.com/shards/#{PLATFORM_REGION}/players?filter[playerNames]=#{player_name}")
    res = self.create_request(uri)
    if description_check(res)
      player_data = JSON.parse(res.body)
      return player_data["data"][0]["id"]
    else

    end
  end

  def self.search_player_rate(player_id, play_mode, season_id)
    uri = URI.parse("https://api.pubg.com/shards/#{PLATFORM_REGION}/players/#{player_id}/seasons/#{season_id}")
    res = self.create_request(uri)
    if description_check(res)
      player_data =JSON.parse(res.body)
      return player_data["data"]["attributes"]["gameModeStats"]["#{play_mode}"]["rankPoints"]
    else
      return nil
    end
  end

  def self.return_rate_object(player_id, season_id)
    uri = URI.parse("https://api.pubg.com/shards/#{PLATFORM_REGION}/players/#{player_id}/seasons/#{season_id}")
    res = self.create_request(uri)
    if description_check(res)
      player_rate = Hash.new
      player_data =JSON.parse(res.body)
      MODES.each do |mode|
        player_rate.store(mode, player_data["data"]["attributes"]["gameModeStats"]["#{mode}"]["rankPoints"])
      end
      return player_rate
    else
      return nil
    end
  end

  def self.get_season_status
    uri = URI.parse("https://api.pubg.com/shards/steam/seasons")
    res = self.create_request(uri)
    if description_check(res)
      season_data = JSON.parse(res.body)
      return season_data["data"].last["id"]
    end
  end

  def self.create_request(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.request_uri)
    req["Authorization"] = "Bearer #{API_KEY}"
    req["Accept"] = "application/vnd.api+json"
    return http.request(req)
  end

  def self.description_check(res)
    case res.code
    when "200"
      return res.body
    else
      return false
    end
  end
end