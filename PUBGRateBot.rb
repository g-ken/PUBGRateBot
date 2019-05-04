require 'discordrb'
require 'dotenv'
require_relative 'lib/bot'

Dotenv.load

module PUBGRateBot
  API_KEY   = ENV['API_KEY']
  PLATFORM  = ENV['PLATFORM']
  TOKEN     = ENV['TOKEN']
  CLIENT_ID = ENV['CLIENT_ID']
  PREFIX    = ENV['PREFIX']
  ENV       = "development"
end

PUBGRateBot::Bot.new.start
