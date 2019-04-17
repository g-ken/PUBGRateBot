require 'gruff'
require_relative '../models/server'
require_relative '../models/user'
require_relative '../models/rate'

module PUBGRateBot
  class CreateGruff
    class << self
      MODE_HASH= {'solo' => '1', 'solo-fpp' => '2', 'duo' => '3', 'duo-fpp' => '4', 'squad' => '5', 'squad-fpp' => '6'}

      def create_day(server_id, mode, date)
        g = Gruff::Line.new
        users = Server.find_by(server_id: server_id).users
        get_day_rate(users, g, date, mode)
        g.labels = {0 => date}
        g.title = "#{mode} day rate"
        g.write("#{'./picture/' + server_id.to_s + '_' + date.to_s + '_' + mode + '_day.png'}")
      end

      def create_week(server_id, mode)
        g = Gruff::Line.new
        users = Server.find_by(server_id: server_id).users
        get_week_rate(users, g, mode)
        g.title = "#{mode} week rate"
        g.write("#{'./picture/' + server_id.to_s + '_' + Date.today.to_s + '_' + mode + '_week.png'}")
      end

      def create_total(server_id, mode)
        g = Gruff::Line.new
        users = Server.find_by(server_id: server_id).users
        get_total_rate(users, g, mode)
        g.title = "#{mode} total rate"
        g.write("#{'./picture/' + server_id.to_s + '_' + Date.today.to_s + '_' + mode + '_total.png'}")
      end

      private
      def get_day_rate(users, g, date, mode)
        users.each do |user|
          data = Array.new
          rates = user.rates.where(["create_at = ? and mode_id = ?", date, MODE_HASH[mode]])
          rates.each do |rate|
            data << rate.rate
          end
          g.data(user.name, data)
        end
      end

      def get_week_rate(users, g, mode)
        labels = Hash.new
        users.each do |user|
          a_week_ago_date = Date.today-6
          data = Rate.find_by_sql(["SELECT rates.rate from rates where rates.mode_id = ? and rates.user_id = ? AND rates.create_at BETWEEN ? AND ?;", MODE_HASH[mode], user.id, a_week_ago_date, a_week_ago_date+6])
          #data = user.rates.where(created_at: [a_week_ago_date..a_week_ago_date+6])
          #7.times do |i|
            #rate = user.rates.where(["create_at = ? and mode_id = ?", date, MODE_HASH[mode]]).last

          #  if rate.nil?
          #    data << nil
          #  else
          #    if rate.rate == 0
          #      data << nil
          #    else
          #      data << rate.rate
          #    end
          #  end
          #  #data << (rate.nil? ? nil : rate.rate)
          #
          #  date += 1
          #end
          7.times do |i|
            labels.store(i, (a_week_ago_date+i).strftime("%m/%d"))
          end
          data.map!{|item| item[:rate]}
          g.data(user.name, data)
        end
        g.labels = labels
      end
      
      def get_total_rate(users, g, mode)
        labels = Hash.new
        oldest = users.order(create_at: :ASC).first.create_at
        labels.store(0, oldest.strftime("%Y/%m/%d"))
        users.each do |user|
          data = Array.new
          (oldest..Date.today).each.with_index(2) do |date, index|
            rate = user.rates.where(["create_at = ? and mode_id = ?", date, MODE_HASH[mode]]).last
            if rate.nil?
              data << nil
            else
              if rate.rate == 0
                data << nil
              else
                data << rate.rate
              end
            end
            #data << (rate.nil? ? nil : rate.rate)
            labels.store(index, nil)
          end
          g.data(user.name, data)
        end
        labels.store((Date.today - oldest).to_i, Date.today.strftime("%Y/%m/%d"))
        g.labels = labels
      end
    end
  end
end
