require_relative 'PubgApi'
require_relative 'TableAction'
require_relative '../models/rate'
require_relative '../models/user'
require_relative '../models/mode'

class ThreadAction < ActiveRecord::Base
  def self.update_rate(season_id)
    User.all.each do | user |
      rate = user.rates.order(updated_at: :DESC).first
      rate_object = PubgApi.return_rate_object(user.player_id, season_id)
      if Time.now.utc.strftime("%Y-%m-%d") > rate.created_at.strftime("%Y-%m-%d")
        TableAction.add_rate_all(user, rate_object)
        puts "add_rate"
      elsif Time.now.utc.strftime("%Y-%m-%d %T") > rate.created_at.strftime("%Y-%m-%d %T")
        TableAction.update_rate_all(user, rate_object)
        puts "update_rate"
      end
    end
  end
end