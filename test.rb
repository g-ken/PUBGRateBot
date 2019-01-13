
#CreateTable.create(YAML.load_file("config/database.yml")["default"]["database"])
require 'discordrb'
require 'dotenv'
require 'json'
require 'yaml'
require 'date'
require 'active_record'
require 'sqlite3'
require 'gruff'
require 'httpclient'

#require_relative 'lib/create-table'
#require_relative 'lib/table-action'
#require_relative 'lib/pubg-api'
#require_relative 'lib/valid-args'
#require_relative 'lib/create-gruff'
#require_relative 'lib/thread-action'
require_relative 'lib/table'

Dotenv.load

class PUBGBot
  attr_accessor :bot, :season_id
  TOKEN     = ENV['TOKEN']
  CLIENT_ID = ENV['CLIENT_ID']
  DB        = ENV['DATABASE']
  PREFIX    = ENV['PREFIX']
  API_KEY   = ENV['API_KEY']
  SLEEP_SEC = ENV['SLEEP_SEC']

  def initialize
    ActiveRecord::Base.establish_connection(YAML.load_file("config/database.yml")["default"])
    Table.create('database')
    @bot = Discordrb::Commands::CommandBot.new token: TOKEN, client_id: CLIENT_ID, prefix: PREFIX

    @bot.command :test do |event, *args|
      event.send_message(event.server.id)
    end

    @bot.command :init do |event|
      Table.init_server(event.server.id)
    end

    @bot.command :add do |event, *args|
      Table.add_user_to_db(event.server.id, args[0])
    end

    @bot.command :rate do |event, *args|
    end

    @bot.command :create_day do |event, *args|
    end

    @bot.command :create_weekly do |event, *args|
    end

    @bot.command :create_total do |event, *args|
    end

    @bot.run
  end
end
PUBGBot.new

