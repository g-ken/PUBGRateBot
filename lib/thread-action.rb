require_relative 'pubg-api'
require_relative 'table-action'
require_relative '../models/rate'
require_relative '../models/user'
require_relative '../models/mode'

class ThreadAction < ActiveRecord::Base
  def self.initialize_create_or_update_rate_action(api_key,season_id)
    #puts 'test3'
    User.all.each do |user|
      #puts 'test4'
      self.create_or_update_rate(api_key, user, season_id)
    end
  end

  def self.create_or_update_rate(api_key, user, season_id)
    #puts 'test_create_or_update_rate'
    rate_date = Date.parse(user.rates.order(updated_at: :DESC).first.created_at.strftime("%Y-%m-%d"))
    #puts 'test5'
    rate_hash = TableAction.get_rate_from_api_to_hash(api_key, user.player_id, season_id)
    #puts 'test6'
    if self.is_rate_created_at_today?(rate_date)
      TableAction.update_user_rate_all_mode(user, rate_hash)
      #puts "update_rate"
    else
      TableAction.create_user_rate_all_mode(user, rate_hash)
      #puts "add_rate"
    end
  end

  def self.is_rate_created_at_today?(rate_date)
    return true if rate_date == Date.today
    return false
  end

  def self.execute_each_sec(sleep_sec)
    yield
    #puts "sleep test1"
    sleep sleep_sec
    #puts "sleep test2"
  end
end