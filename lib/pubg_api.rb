require 'httpclient'

module PUBGRateBot
  ### APIに関するモジュール
  module PUBGApi
    BASE_URL =  "https://api.pubg.com/shards/steam"

    # APIサーバからJSONを取得する
    # @param [String] player_name プレイヤーネーム
    # @return [String] リクエスト結果のJSON
    def fetch_from_players(player_name)
      url = "#{BASE_URL}/players?filter[playerNames]=#{player_name}"
      http_request(url)
    end

    # APIサーバからJSONを取得する
    # @return [String] リクエスト結果のJSON
    def fetch_from_seasons
      url = "#{BASE_URL}/seasons"
      http_request(url)
    end

    # APIサーバからJSONを取得する
    # @param [String] player_id ゲーム内ID
    # @param [String] season_id シーズンID
    # @return [String] リクエスト結果のJSON
    def fetch_from_seasons_stats(player_id, season_id)
      url = "#{BASE_URL}/players/#{player_id}/seasons/#{season_id}"
      http_request(url)
    end

    private

    # APIキーをヘッダーに埋め込んでurlに対してgetリクエストを行う
    # @param [String] url リクエスト先のURL
    # @return [String] リクエスト結果のJSON
    #
    def http_request(url)
      client = HTTPClient.new
      header = [["Authorization", "Bearer #{API_KEY}"], ["Accept", "application/vnd.api+json"]]
      client.get(url, header: header)
    end
  end
end
