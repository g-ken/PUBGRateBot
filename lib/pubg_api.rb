require 'httpclient'
require_relative './shape'

module PUBGRateBot
  class PUBGApi
    @@season_id = nil
    BASE_URL =  "https://api.pubg.com/shards/steam/"
    API_KEY  =  ENV['API_KEY']
    class << self
      def feach_player_state(pubg_name)
        url  =  BASE_URL + "players?filter[playerNames]=" + pubg_name
        data =  request_data(url)
        if is_correct_res?(data)
          return Shape.extract_account_id(data) 
        else
          return nil
        end
      end

      def feach_season
        url  =  BASE_URL + "seasons"
        data =  request_data(url)
        @@season_id = Shape.extract_season_id(data) if is_correct_res?(data)
      end

      def feach_player_season_state(player_id)
        url  =  BASE_URL + "players/" + player_id + "/seasons/" + @@season_id.to_s
        data =  request_data(url)
        puts data.status
        if is_correct_res?(data)
          return Shape.extract_rate_hash(data)
        else
          return nil
        end
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

      def is_correct_res?(data)
        data.status == 200 ? true : false
      end
    end
  end
end