require_relative 'table'
require_relative 'create_gruff'

module PUBGRateBot
  class Command
    def initialize(token, client_id, prefix)
      @bot = Discordrb::Commands::CommandBot.new token: token, client_id: client_id, prefix: prefix
      ActiveRecord::Base.establish_connection(YAML.load_file("config/database.yml")["default"])
      Table.create(YAML.load_file("config/database.yml")["default"]["database"])

      @bot.command :add do |event, pubg_name|
        Table.add_user(event.server.id, pubg_name)
      end

      @bot.command :rate do |event, pubg_name|
        event.send_embed do |embed|
          Table.get_rate(event.server.id, pubg_name, embed)
        end
      end

      @bot.command :test do |event, pubg_name|
      end

      @bot.command :create_day do |event, date = nil|
        CreateGruff.create_today(event.server.id, date)
      end

      @bot.command :create_week do |event|
        CreateGruff.create_week(event.server.id)
      end

      @bot.command :create_week do |event|
        CreateGruff.create_week(event.server.id)
      end

      @bot.command :create_total do |event|
        CreateGruff.create_total(event.server.id)
      end
    end
    
    def start
      @bot.run
    end
  end
end