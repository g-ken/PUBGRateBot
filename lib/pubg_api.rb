require 'httpclient'
require_relative './shape'

module PUBGRateBot
  class PUBGApi
    @@season_id = nil
    BASE_URL =  "https://api.pubg.com/shards/steam/"
    
    class << self
      def feach_player_state(pubg_name)
        url  =  BASE_URL + "players?filter[playerNames]=" + pubg_name
        return request_data(url)
      end

      def feach_player_season_state(player_id)
        url  =  BASE_URL + "players/" + player_id + "/seasons/" + @@season_id.to_s
        return request_data(url)
      end

      def feach_season
        url  =  BASE_URL + "seasons"
        data =  request_data(url)
        @@season_id = Shape.extract_season_id(data) if data.status == 200
      end

      def season_id
        @@season_id
      end
    
      def season_id=(val)
        @@season_id = val
      end

      private
      def request_data(url)
        client = HTTPClient.new
        header = [["Authorization", "Bearer #{API_KEY}"], ["Accept", "application/vnd.api+json"]]
        return client.get(url, header: header)
      end
    end
  end
end