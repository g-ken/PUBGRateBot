require 'discordrb'
require 'dotenv'
require 'active_record'
require 'net/http'
require 'uri'
require 'json'
require 'gruff'
require 'date'

require './lib/CreateTable'
require './lib/PubgApi'
require './lib/ValidArgs'
require './lib/TableAction'
require './lib/CreateGruff'
require './lib/ThreadAction'

Dotenv.load

class PubgBot
  attr_accessor :bot
  TOKEN = ENV['TOKEN']
  CLIENT_ID = ENV['CLIENT_ID']
  DB = ENV['DATABASE']
  PREFIX = ENV['PREFIX']

  def initialize
    @bot = Discordrb::Commands::CommandBot.new token: TOKEN, client_id: CLIENT_ID, prefix: PREFIX
    db = "./db/#{DB}"
    ActiveRecord::Base.establish_connection(
      "adapter" => "sqlite3",
      "database" => db,
      "pool" => 1
    )

    CreateTable.create(db)

    @season_id = PubgApi.get_season_status
    @modes = Mode.all
  end

  def start
    setting
    @bot.run
  end
  def setting
    @bot.command :add do | event, *args |
      if ValidArgs.first_valid(args, 1)
        message = TableAction.add_user(args[0], @season_id)
        event.send_message "#{message}"
      else
        event.send_message "Args over length. Check !help command"
      end
    end

    @bot.command :delete do | event, *args |
      message = TableAction.delete_user(args[0])
      puts message
    end

    @bot.command :rate do | event, *args |
      if ValidArgs.first_valid(args,2)
        if ValidArgs.equal_valid(args, 2)
          player_id = PubgApi.search_player_id(args[1])
          rate = PubgApi.search_player_rate(player_id, args[0], @season_id)
          event.send_message %(#{args[1]}'s #{args[0]} rate is #{rate}) unless rate.nil?
        else
          event.send_message "Args length wrong. Check !help command"
        end
      else
        event.send_message "Args over length. Check !help command"
      end
    end

    @bot.command :create do | event, mode, *args |
      if ValidArgs.equal_valid(args, 0)
        CreateGruff.create_gruff(mode, args)
        event.send_message "Success"
        event.send_file(File.open('all_rate_gruff.png', 'r'))
      else 
        if ValidArgs.player_valid(args)
          CreateGruff.create_player_gruff(mode, args)
          event.send_message "Success"
          event.send_file(File.open('player_rate_gruff.png', 'r'))
        else
          event.send_message "Not found player"
        end
      end
    end

    @bot.command :help do | event, args |
      case args
      when nil then
        help_text = <<-EOS
prefix: #{PREFIX}
  rate: Display rate by mode.
  add  Add rate database.
  create: Create rate line gruff.
If you want know usage
  #{PREFIX}help [command]
        EOS
      when "rate" then
        help_text = <<-EOS
Usage: #{PREFIX}rate [mode] [pubg_name]
  mode: solo solo-fpp duo duo-fpp squad squad-fpp
        EOS
      when "add" then
        help_text = <<-EOS
          Usage: #{PREFIX}add [pubg_name]
If you want to use create command, this command is necessary.
        EOS
      when "create" then
        help_text = <<-EOS
Usage: #{PREFIX}create [mode] [pubg_name1 pubg_name2 ...]
  mode: solo solo-fpp duo duo-fpp squad squad-fpp
  pubg_name is option.
  No option execution command then output all player rate gruff.
        EOS
      else
        help_text = <<-EOS
          Not fount help option command.
        EOS
      end
    end

    @bot.command :test do | event, *args |
      ThreadAction.update_rate(@season_id)
    end
    
    Thread.new do
      loop do
        TableAction.execute_each_sec(900) do ||
          ActiveRecord::Base.connection_pool.with_connection do
            ThreadAction.update_rate(@season_id)
          end
        end
      end
    end
  end
end

pubgbot = PubgBot.new
pubgbot.start
