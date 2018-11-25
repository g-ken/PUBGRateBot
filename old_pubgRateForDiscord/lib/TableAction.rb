require_relative 'PubgApi'
require_relative '../models/rate'
require_relative '../models/user'
require_relative '../models/mode'

class TableAction < ActiveRecord::Base
  def self.add_user(player_name, season_id)
    if self.search_user(player_name)
      return "#{player_name} has already been registered"
    else
      player_id = PubgApi.search_player_id(player_name)
      if player_id
        User.new(player_name: "#{player_name}", player_id: "#{player_id}").save
        user = User.find_by(player_name: "#{player_name}")
        player_object = PubgApi.return_rate_object(player_id, season_id)
        self.add_rate_all(user, player_object)
        return %(#{player_name} sccessed register)
      else
        return %(#{player_name} can't register)
      end
    end
  end

  def self.add_rate(user, player_rate, mode_id)
    user.rates.create(player_rate: "#{player_rate}", mode_id: "#{mode_id}")
  end

  def self.update_rate(rate, player_rate)
    rate.update(player_rate: "#{player_rate}")
  end

  def self.delete_user(player_name)
    user = self.search_user(player_name)
    if user
      user.destroy
      return "Success delete user"
    else
      return "Failure delete user"
    end
  end

  def self.search_user(player_name)
    return User.find_by(player_name: "#{player_name}")
  end

  def self.add_rate_all(user, rate_object)
    user.rates.create(player_rate: rate_object["solo"], mode_id: 1)
    user.rates.create(player_rate: rate_object["solo-fpp"], mode_id: 2)
    user.rates.create(player_rate: rate_object["duo"], mode_id: 3)
    user.rates.create(player_rate: rate_object["duo-fpp"], mode_id: 4)
    user.rates.create(player_rate: rate_object["squad"], mode_id: 5)
    user.rates.create(player_rate: rate_object["squad-fpp"], mode_id: 6)
  end

  def self.update_rate_all(user, rate_object)
    user.rates.where(mode_id: 1).order(created_at: :DESC).first.update(player_rate: rate_object["solo"])
    user.rates.where(mode_id: 2).order(created_at: :DESC).first.update(player_rate: rate_object["solo-fpp"])
    user.rates.where(mode_id: 3).order(created_at: :DESC).first.update(player_rate: rate_object["duo"])
    user.rates.where(mode_id: 4).order(created_at: :DESC).first.update(player_rate: rate_object["duo-fpp"])
    user.rates.where(mode_id: 5).order(created_at: :DESC).first.update(player_rate: rate_object["squad"])
    user.rates.where(mode_id: 6).order(created_at: :DESC).first.update(player_rate: rate_object["squad-fpp"])
  end

  def self.execute_each_sec(sleep_sec)
    yield
    sleep sleep_sec
  end
end