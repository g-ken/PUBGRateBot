# module PUBGApi
#   #リクエストＵＲＬの先頭につける
#   BASE_URL = "https://api.pubg.com/shards/steam/"
#   class << self
#     #名前からＩＤを調べたりするのに使う
#     def get_player_stats(api_key, player_name)
#       url = BASE_URL + "players?filter[playerNames]=" + player_name
#       return request_data(api_key, url)
#     end
# 
#     #シーズンデータを取得する
#     def get_seasons(api_key)
#       url = BASE_URL + "seasons"
#       return request_data(api_key, url)
#     end
# 
#     #プレイヤーのシーズンでのデータを取得する
#     def get_player_season_stats(api_key, player_id, season_id)
#       url = BASE_URL + "players/" + player_id + "/seasons/" + season_id.to_s
#       return request_data(api_key, url)
#     end
# 
#     #プレイヤーの通算のデータを取得する
#     def get_player_lifetime_stats(api_key, player_id)
#       url = BASE_URL + "players/" + player_id
#       return request_data(api_key, url)
#     end
# 
#     #リクエストの送信
#     def request_data(api_key, url)
#       client = HTTPClient.new
#       header = [["Authorization", "Bearer #{api_key}"], ["Accept", "application/vnd.api+json"]]
#       return client.get(url, header: header)
#     end
#   end
# end