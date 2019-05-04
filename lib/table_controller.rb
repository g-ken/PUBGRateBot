require_relative "pubg_api"
require_relative "../models/user"
require_relative "../models/detail"
require_relative "../models/server"
require_relative "../models/season"
require_relative "../models/rank_point"

module PUBGRateBot
  class TableController
    attr_accessor :user
    attr_reader   :season, :server
    def initialize(**setup)
      @user   = nil
      @server = nil
      @api    = PUBGApi.new
      @season = setup[:season] ? setup_season : nil
    end

    # サーバとユーザレコードを関連付ける
    # @param [String] server_id
    # @param [String] player_name
    def add_user(server_id, player_name)
      @server = retrieve_server(server_id)
      @user   = retrieve_user(player_name)
      @server.users << @user unless exists_servers_user?
    end

    def retrieve_rank_points(player_name)
      @user   = retrieve_user(player_name)
      @season = retrieve_latest_season
      _retrieve_rank_points
    end

    # ランクポイントレコードの差分を取って更新する
    def register_user_rank_points
      latest_rank_point     = _retrieve_rank_points
      current_rank_point    = request_rank_point
      diff_rank_point_array = diff_rank_point(latest_rank_point, current_rank_point)
      diff_rank_point_array.each{|rank_point, mode_id| _register_user_rank_point(rank_point, mode_id)}
    end

    private

    # シーズンIDを取得し,まだ登録されてなければ登録する
    def setup_season
      season_id  = request_season_id
      Season.find_or_create_by(season_id: season_id)
    end

    # 実行日の最新レートレコードを取得する
    # @return [Array] 実行日のランクポイントが格納された配列 [123,456,789,123,456,789]
    def _retrieve_rank_points(date = Date.today)
      @user.rank_points.where(created_at: date, season_id: @season.id).group(:mode_id).map(&:point)
    end

    # ユーザレコードにランクポイントレコードを関連生成する
    # @param [Integer] rank_point
    # @param [Integer] mode_id
    def _register_user_rank_point(rank_point, mode_id)
      @user.rank_points.create(point: rank_point, mode_id: mode_id, season_id: @season.id, created_at: Date.today) if rank_point
    end

    def request_season_id
      @api.fetch_season_id
    end

    def request_account_id(player_name)
      @api.fetch_account_id(player_name)
    end

    def request_rank_point
      account_id = @user.detail.account_id
      season_id  = @season.season_id
      @api.fetch_rank_point(account_id, season_id)
    end


    # 該当するシーズンレコードが存在するか
    # @param [String] season_id
    # @return [Boolean]
    def exists_season?(season_id)
      Season.exists?(season_id: season_id)
    end

    # ユーザがサーバレコードと関連付けられているか確かめる
    def exists_servers_user?
      @server.users.exists?(id: @user.id)
    end

    # ユーザを検索する
    # @param [String] player_name
    def retrieve_user(player_name)
      Detail.create_with(
          player_name: player_name,
          account_id:  request_account_id(player_name),
          ).find_or_create_by(player_name: player_name).user
    end

    def retrieve_server(server_id)
      Server.find_or_create_by(server_id: server_id)
    end

    # 最新のシーズンレコードを返す
    # @return [Object]
    def retrieve_latest_season
      Season.last
    end

    # 最新レコードと最新APIのランクポイントの差分を取る
    # @param [Array] latest_rates
    # @param [Array] current_rates
    # @return [Array] [[rank_point, mode_id],]
    def diff_rank_point(latest_rates, current_rates)
      current_rates.zip(latest_rates).map.with_index(1) do |current_latest, mode_id|
        current_latest[0] != current_latest[1] ? [current_latest[0], mode_id] : next
      end
    end
  end
end
