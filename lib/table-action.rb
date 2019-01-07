require_relative 'pubg-api'
require_relative '../models/rate'
require_relative '../models/user'
require_relative '../models/mode'

class TableAction < ActiveRecord::Base
  include PUBGApi
  class << self
    def add_user_to_db(api_key, player_name, season_id)
      if is_exist_player?(player_name)
        return "#{player_name} is already registered"
      else
        res = PUBGApi.get_player_stats(api_key, player_name)
        if is_correct_response?(res)
          if User.new(player_name: player_name, player_id: JSON.parse(res.body)["data"][0]["id"]).save
            add_all_mode_rate_to_db(api_key, player_name, season_id)
            return "Register id success"
          else
            return "Register is failed" 
          end
        else
          return "Faild api request. Status is #{res.status}"
        end
      end
    end

    def add_all_mode_rate_to_db(api_key, player_name, season_id)
      user = User.find_by(player_name: player_name)
      rate_hash = get_rate_from_api_to_hash(api_key, user.player_id, season_id)
      create_user_rate_all_mode(user, rate_hash)
    end

    def update_all_mode_rate_to_db(api_key, player_name, season_id)
      user = User.find_by(player_name: player_name)
      rate_hash = get_rate_from_api_to_hash(api_key, user.player_id, season_id)
      update_user_rate_all_mode(user, rate_hash)
    end
    
    def search_all_mode_rate_from_db(player_name)
      user = User.find_by(player_name: player_name)
      return get_rate_from_db_to_hash(user)
    end

    #ＤＢに既存ならＴそれ以外ならＦ
    def is_exist_player?(player_name)
      return true if User.find_by(player_name: player_name)
      return false
    end

    #現在のシーズンのＩＤを返す
    def get_current_season_id(api_key)
      res = PUBGApi.get_seasons(api_key)
      return JSON.parse(res.body)["data"].last["id"] if is_correct_response?(res)
    end

    #statusが200ならＴそれ以外はＦ
    def is_correct_response?(data)
      return true if data.status == 200
      return false
    end

    #レートをハッシュで返す。例：{solo: 1500, solo-fpp: 1500, 〜}
    def get_rate_from_api_to_hash(api_key, player_id, season_id)
      res = PUBGApi.get_player_season_stats(api_key, player_id, season_id) 
      if is_correct_response?(res)
        return {
        "solo":      JSON.parse(res.body)["data"]["attributes"]["gameModeStats"]["solo"]["rankPoints"],
        "solo-fpp":  JSON.parse(res.body)["data"]["attributes"]["gameModeStats"]["solo-fpp"]["rankPoints"],
        "duo":       JSON.parse(res.body)["data"]["attributes"]["gameModeStats"]["duo"]["rankPoints"],
        "duo-fpp":   JSON.parse(res.body)["data"]["attributes"]["gameModeStats"]["duo-fpp"]["rankPoints"],
        "squad":     JSON.parse(res.body)["data"]["attributes"]["gameModeStats"]["squad"]["rankPoints"],
        "squad-fpp": JSON.parse(res.body)["data"]["attributes"]["gameModeStats"]["squad-fpp"]["rankPoints"],
        }
      end
    end

    def get_rate_from_db_to_hash(user)
      return {
        "solo":      user.rates.where(mode_id: 1).order(created_at: :DESC).first.player_rate,
        "solo-fpp":  user.rates.where(mode_id: 2).order(created_at: :DESC).first.player_rate,
        "duo":       user.rates.where(mode_id: 3).order(created_at: :DESC).first.player_rate,
        "duo-fpp":   user.rates.where(mode_id: 4).order(created_at: :DESC).first.player_rate,
        "squad":     user.rates.where(mode_id: 5).order(created_at: :DESC).first.player_rate,
        "squad-fpp": user.rates.where(mode_id: 6).order(created_at: :DESC).first.player_rate,
      }
    end

    def create_user_rate_all_mode(user, rate_hash)
      user.rates.create(player_rate: rate_hash[:"solo"]      , mode_id: 1)
      user.rates.create(player_rate: rate_hash[:"solo-fpp"]  , mode_id: 2)
      user.rates.create(player_rate: rate_hash[:"duo"]       , mode_id: 3)
      user.rates.create(player_rate: rate_hash[:"duo-fpp"]   , mode_id: 4)
      user.rates.create(player_rate: rate_hash[:"squad"]     , mode_id: 5)
      user.rates.create(player_rate: rate_hash[:"squad-fpp"] , mode_id: 6)
    end

    def update_user_rate_all_mode(user, rate_hash)
      user.rates.where(mode_id: 1).order(created_at: :DESC).first.update(player_rate: rate_hash[:"solo"])
      user.rates.where(mode_id: 2).order(created_at: :DESC).first.update(player_rate: rate_hash[:"solo-fpp"])
      user.rates.where(mode_id: 3).order(created_at: :DESC).first.update(player_rate: rate_hash[:"duo"])
      user.rates.where(mode_id: 4).order(created_at: :DESC).first.update(player_rate: rate_hash[:"duo-fpp"])
      user.rates.where(mode_id: 5).order(created_at: :DESC).first.update(player_rate: rate_hash[:"squad"])
      user.rates.where(mode_id: 6).order(created_at: :DESC).first.update(player_rate: rate_hash[:"squad-fpp"])
    end
  end
end