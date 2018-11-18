require_relative '../models/rate'
require_relative '../models/user'
require_relative '../models/mode'

class CreateGruff < ActiveRecord::Base
  def self.create_gruff(mode,args)
    g = Gruff::Line.new
    mode = Mode.find_by(play_mode: mode)
    oldest = Date.parse(Rate.where(mode_id: mode.id).order(created_at: :ASC).first.created_at.strftime("%Y-%m-%d"))
    User.all.each do | user |
      data = Array.new
      old = oldest
      user.rates.where(mode_id: mode.id).order(created_at: :ASC).each do | rate |
        loop do
          if old == Date.parse(rate.created_at.strftime("%Y-%m-%d"))
            data << rate.player_rate
          elsif old > Date.parse(rate.created_at.strftime("%Y-%m-%d"))
            break
          else
            data << nil
          end
          old+=1
        end
      end
      g.data user.player_name, data
    end
    g.title = "PUBG Rate"
    date = Hash.new
    (oldest..Date.parse(Time.now.utc.strftime("%Y-%m-%d"))).each do | each_date |
      date.store((each_date-oldest).to_i, each_date)
    end
    g.labels = date
    g.write('all_rate_gruff.png')
  end

  def self.create_player_gruff(mode, players)
    g = Gruff::Line.new
    users = Array.new
    title = Array.new
    mode = Mode.find_by(play_mode: mode)
    oldest = Date.parse(Time.now.utc.strftime("%Y-%m-%d"))
    players.each do | player |
      user = User.find_by(player_name: player)
      oldest = Date.parse(user.rates.where(mode_id: mode.id).order(created_at: :ASC).first.created_at.strftime("%Y-%m-%d")) if Date.parse(user.rates.all.order(created_at: :ASC).first.created_at.strftime("%Y-%m-%d")) < oldest
      users << user
    end
    users.each do | user |
      data = Array.new
      old = oldest
      user.rates.where(mode_id: mode.id).order(created_at: :ASC).each do | rate |
        loop do
          if old == Date.parse(rate.created_at.strftime("%Y-%m-%d"))
            data << rate.player_rate
          elsif old > Date.parse(rate.created_at.strftime("%Y-%m-%d"))
            break
          else
            data << nil
          end
          old += 1
        end
      end
      g.data user.player_name, data
    end
    date = Hash.new
    (oldest..Date.parse(Time.now.utc.strftime("%Y-%m-%d"))).each do | each_date |
      date.store((each_date-oldest).to_i, each_date)
    end
    g.title = mode.play_mode
    g.labels = date
    g.write('player_rate_gruff.png')
  end
end