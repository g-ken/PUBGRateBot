require_relative 'table'
require_relative 'command'
require_relative 'job_runner'

module PUBGRateBot
  class Bot
    def initialize
      create_conn
      setup_database
      create_commandbot
      setup_command
      start_job
    end

    def start
      @bot.run
    end

    private

    def create_conn
      db_yaml = YAML.load_file("config/database.yml")
      ActiveRecord::Base.establish_connection(db_yaml[ENV])
    end

    def setup_database
      Table.migrate unless validate_database_table
    end

    def validate_database_table
      %w{servers servers_users users details rank_points seasons} == ActiveRecord::Base.connection.tables
    end

    def create_commandbot
      @bot = Discordrb::Commands::CommandBot.new(token: TOKEN, client_id: CLIENT_ID, prefix: PREFIX)
    end

    def setup_command
      @bot.command(:add, {:usage => ""}) do |event, player_name|
        embed = Command.add(event.server.id, player_name)
        event.send_message('', false, embed)
      end

      @bot.command(:rate,{:usage => ""}) do |event, player_name|
        embed = Command.rate(player_name)
        event.send_message('', false, embed)
      end

      @bot.command(:day,    {:usage => ""}) do |event, mode|

      end

      @bot.command(:week,   {:usage => ""}) do |event, mode|

      end

      @bot.command(:season, {:usage => ""}) do |event, mode|

      end

      @bot.command(:total,  {:usage => ""}) do |event, mode|

      end
    end

    def start_job
      JobRunner.update_rate_job
    end
  end
end
