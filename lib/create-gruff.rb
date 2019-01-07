require_relative '../models/rate'
require_relative '../models/user'
require_relative '../models/mode'

module CreateGruff
  def self.create_gruff_all_user(mode)
    g = Gruff::Line.new
    users = Array.new
    mode = Mode.find_by(play_mode: mode)
    oldest_date = Date.parse(User.all.order(created_at: :ASC).first.created_at.strftime("%Y-%m-%d"))
    User.all.each do |user|
      g.data user.player_name, self.get_user_rate_from_oldest_to_now(mode.id, user, oldest_date)
    end
    g.labels = self.get_rate_date_oldest_and_now(oldest_date)
    g.write('gruff.png')
  end

  def self.create_gruff_specific_user(mode, players_name)
    g = Gruff::Line.new
    users = Array.new
    mode = Mode.find_by(play_mode: mode)
    oldest_date = Date.parse(User.where(player_name: players_name).order(created_at: :ASC).first.created_at.strftime("%Y-%m-%d"))
    players_name.each do |player_name|
      users << User.find_by(player_name: player_name)
    end
    users.each do |user|
      g.data user.player_name, self.get_user_rate_from_oldest_to_now(mode.id, user, oldest_date)
    end
    g.labels = self.get_rate_date_oldest_and_now(oldest_date)
    g.write('gruff.png')
  end

  def self.get_user_rate_from_oldest_to_now(mode_id, user, oldest_date)
    data = Array.new
    old = oldest_date
    user.rates.where(mode_id: mode_id).order(created_at: :ASC).each do | rate |
      loop do
        if old == Date.parse(rate.created_at.strftime("%Y-%m-%d"))
          rate.player_rate != 0 ? data << rate.player_rate : data << nil
        elsif old > Date.parse(rate.created_at.strftime("%Y-%m-%d"))
          break
        else
          data << nil
        end
        old+=1
      end
    end
    return data
  end

  def self.get_rate_date_oldest_and_now(oldest_date)
    today_date = Date.parse(Time.now.utc.strftime("%Y-%m-%d"))
    date_array = Array.new(today_date - oldest_date+1)
    date_array[0] = oldest_date
    date_array[date_array.length-1] = (today_date)
    number_array = [*(0..(today_date - oldest_date))]
    return [number_array, date_array].transpose.to_h
  end
end