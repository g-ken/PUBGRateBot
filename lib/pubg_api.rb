require 'httpclient'

module PUBGRateBot
  class PUBGApi
    BASE_URL =  "https://api.pubg.com/shards/steam/"
    API_KEY  =  ENV['API_KEY']
    class << self
      def feach_player_state(pubg_name)
        url  =  BASE_URL + "players?filter[playerNames]=" + pubg_name
        data =  request_data(url)
        is_correct_res?(data) ? data : nil
      end

      def feach_season
        url  =  BASE_URL + "seasons"
        data =  request_data(url)
        is_correct_res?(data) ? data : nil
      end

      def feach_player_season_state(player_id, season_id)
        url  =  BASE_URL + "players/" + player_id + "/seasons/" + season_id.to_s
        data =  request_data(url)
        is_correct_res?(data) ? data : nil
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