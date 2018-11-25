module PUBGApi
  #リクエストＵＲＬの先頭につける
  BASE_URL = "https://api.pubg.com/shards/steam/"

  #名前からＩＤを調べたりするのに使う
  def get_player_stats(api_key, player_name)
    url = BASE_URL + "players?filter[playerNames]=" + player_name
    return request_data(api_key, url)
  end
  module_function :get_player_stats

  #シーズンデータを取得する
  def get_seasons(api_key)
    url = BASE_URL + "seasons"
    return request_data(api_key, url)
  end
  module_function :get_seasons

  #プレイヤーのシーズンでのデータを取得する
  def get_player_season_stats(api_key, player_id, season_id)
    url = BASE_URL + "players/" + player_id + "/seasons/" + season_id.to_s
    return request_data(api_key, url)
  end
  module_function :get_player_season_stats

  #プレイヤーの通算のデータを取得する
  def get_player_lifetime_stats(api_key, player_id)
    url = BASE_URL + "players/" + player_id
    return request_data(api_key, url)
  end
  module_function :get_player_lifetime_stats

  #リクエストの送信
  def request_data(api_key, url)
    client = HTTPClient.new
    header = [["Authorization", "Bearer #{api_key}"], ["Accept", "application/vnd.api+json"]]
    return client.get(url, header: header)
  end
  module_function :request_data
end

#eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJmNGNhMzM3MC1jMjc4LTAxMzYtN2YzYS0zZDI3Mjk5MmUyMmQiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNTQxMzQ3MzUwLCJwdWIiOiJibHVlaG9sZSIsInRpdGxlIjoicHViZyIsImFwcCI6InB1YmdfcmF0ZV9mb3JfIn0.o23cuL9Xy1VPxpz-gS66wgfQJOnzcBAcK98sGOquFfY