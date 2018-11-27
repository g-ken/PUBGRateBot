require 'discordrb'
require 'dotenv'
require 'json'
require 'yaml'
require 'date'
require 'active_record'
require 'sqlite3'
require 'gruff'
require 'httpclient'

require_relative 'lib/create-table'
require_relative 'lib/table-action'
require_relative 'lib/pubg-api'
require_relative 'lib/valid-args'
require_relative 'lib/create-gruff'
require_relative 'lib/thread-action'

Dotenv.load

class PUBGBot
  attr_accessor :bot, :season_id
  TOKEN = ENV['TOKEN']
  CLIENT_ID = ENV['CLIENT_ID']
  DB = ENV['DATABASE']
  PREFIX = ENV['PREFIX']
  API_KEY = ENV['API_KEY']
  SLEEP_SEC = ENV['SLEEP_SEC']

  def initialize
    @bot = Discordrb::Commands::CommandBot.new token: TOKEN, client_id: CLIENT_ID, prefix: PREFIX
    ActiveRecord::Base.establish_connection(YAML.load_file("config/database.yml")["default"])
    CreateTable.create(YAML.load_file("config/database.yml")["default"]["database"])
    @season_id = TableAction.get_current_season_id(API_KEY)
    
    Thread.new do
      #puts 'test0'
      loop do
        #puts 'test1'
        ThreadAction.execute_each_sec(SLEEP_SEC.to_i) do ||
          #puts 'test2'
          ActiveRecord::Base.connection_pool.with_connection do
            ThreadAction.initialize_create_or_update_rate_action(API_KEY, @season_id)
          end
        end
      end
    end

    Thread.new do
      loop do
        ThreadAction.execute_each_sec(3600) do ||
          #puts "test1"
          @season_id = TableAction.get_current_season_id(API_KEY)
          #puts @season_id
        end
      end
    end
  end

  def start
    setting
    @bot.run
  end

  def setting
    @bot.command :add do |event, *args|
      if ValidArgs.is_args_equal_number?(args, 1)
        message = TableAction.add_user_to_db(API_KEY, args[0], @season_id)
        event.send_message "#{message}"
      else
        event.send_message "Wrong number of arguments . Check !help command"
      end
    end

    @bot.command :rate do |event, *args|
      if ValidArgs.is_args_equal_number?(args, 1)
        if TableAction.is_exist_player?(args[0])
          rate_hash = TableAction.search_all_mode_rate_from_db(args[0])
          message = <<~EOS
          solo:      #{rate_hash[:solo]        != 0 ? rate_hash[:solo]        : "No data"}
          duo:       #{rate_hash[:duo]         != 0 ? rate_hash[:duo]         : "No data"}
          squad:     #{rate_hash[:squad]       != 0 ? rate_hash[:squad]       : "No data"}
          solo-fpp:  #{rate_hash[:"solo-fpp"]  != 0 ? rate_hash[:"solo-fpp"]  : "No data"}
          duo-fpp:   #{rate_hash[:"duo-fpp"]   != 0 ? rate_hash[:"duo-fpp"]   : "No data"}
          squad-fpp: #{rate_hash[:"squad-fpp"] != 0 ? rate_hash[:"squad-fpp"] : "No data"}
          EOS
          event.send_message "#{message}"
        else
          event.send_message "Can't found player"
        end
      else
        event.send_message "Wrong number of arguments . Check !help command"
      end
    end

    @bot.command :create do |event, mode, *args|
      if ValidArgs.is_args_equal_number?(args, 0)
        if ValidArgs.is_exist_mode?(mode)
          CreateGruff.create_gruff_all_user(mode)
          event.send_message "Success"
          event.send_file(File.open('gruff.png', 'r'))
        else
          event.send_message "Wrong status of argument."
        end
      elsif ValidArgs.is_args_larger_than_number?(args, 0)
        if ValidArgs.is_exist_mode?(mode) && ValidArgs.is_exist_player?(args)
          CreateGruff.create_gruff_specific_user(mode, args)
          event.send_message "Success"
          event.send_file(File.open('gruff.png', 'r'))
        else
          event.send_message "Wrong status of argument."
        end
      else
        event.send_message "Wrong number of arguments . Check !help command"
      end
    end
  end
end

pubgbot = PUBGBot.new
pubgbot.start