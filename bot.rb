require 'discordrb'
require 'dotenv'
require_relative './lib/command.rb'

Dotenv.load

TOKEN     = ENV['TOKEN']
CLIENT_ID = ENV['CLIENT_ID']
PREFIX    = ENV['PREFIX']
module PUBGRateBot
  DB        = ENV['DATABASE']
  API_KEY   = ENV['API_KEY']
  SLEEP_SEC = ENV['SLEEP_SEC']
end

bot   = PUBGRateBot::Command.new(TOKEN, CLIENT_ID, PREFIX)
bot.start