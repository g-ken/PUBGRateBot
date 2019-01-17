require_relative './table'
require_relative './create_gruff'
require_relative './thread'

module PUBGRateBot
  class Command
    def initialize(token, client_id, prefix)
      @bot = Discordrb::Commands::CommandBot.new token: token, client_id: client_id, prefix: prefix
      ActiveRecord::Base.establish_connection(YAML.load_file("config/database.yml")["default"])
      Table.create(YAML.load_file("config/database.yml")["default"]["database"])

      ThreadAction.every_hour_update_season_id
      sleep(5)
      ThreadAction.five_minute_update_user_rate

      @bot.command :add do |event, pubg_name|
        Table.add_user(event.server.id, pubg_name)
      end

      @bot.command :rate do |event, pubg_name|
        event.send_embed do |embed|
          Table.get_rate(event.server.id, pubg_name, embed)
        end
      end

      @bot.command :create do |event, mode|
        CreateGruff.create_total(event.server.id, mode)
        event.send_file(File.open("#{File.expand_path("../..", __FILE__) + '/picture/' + event.server.id.to_s + '_' + Date.today.to_s + '_' + mode + '_total.png'}", 'r'))
      end

      @bot.command :create_day do |event, mode, date = Date.today|
        CreateGruff.create_day(event.server.id, mode, date)
        event.send_file(File.open("#{File.expand_path("../..", __FILE__) + '/picture/' + event.server.id.to_s + '_' + date.to_s + '_' + mode + '_day.png'}", 'r'))
      end

      @bot.command :create_week do |event, mode|
        CreateGruff.create_week(event.server.id, mode)
        event.send_file(File.open("#{File.expand_path("../..", __FILE__) + '/picture/' + event.server.id.to_s + '_' + Date.today.to_s + '_' + mode + '_week.png'}", 'r'))
      end

      @bot.command :create_total do |event, mode|
        CreateGruff.create_total(event.server.id, mode)
        event.send_file(File.open("#{File.expand_path("../..", __FILE__) + '/picture/' + event.server.id.to_s + '_' + Date.today.to_s + '_' + mode + '_total.png'}", 'r'))
      end
    end
    
    def start
      @bot.run
    end
  end
end