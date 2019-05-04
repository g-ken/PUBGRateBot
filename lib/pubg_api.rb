require 'httpclient'
require_relative 'response_parser'

module PUBGRateBot
  ### APIに関するクラス
  # こんにちはこんばんはこんばんはこんばんは
  class PUBGApi
    def initialize
      @client = HTTPClient.new
      @client.base_url = "https://api.pubg.com/shards/#{PLATFORM}/"
      @header = [["Authorization", "Bearer #{API_KEY}"], ["Accept", "application/vnd.api+json"]]
    end

    def fetch_season_id
      res = @client.get("seasons", header: @header)
      ResponseParser.extract_season_id(res)
    end

    def fetch_account_id(player_name)
      res = @client.get("players?filter[playerNames]=#{player_name}", header: @header)
      ResponseParser.extract_account_id(res)
    end

    def fetch_rank_point(account_id, season_id)
      res = @client.get("players/#{account_id}/seasons/#{season_id}", header: @header)
      ResponseParser.extract_rank_point(res)
    end
  end
end
