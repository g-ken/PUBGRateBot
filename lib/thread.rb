require_relative 'table'
require_relative 'pubg_api'
require_relative '../models/rate'
require_relative '../models/user'

Dotenv.load

module PUBGRateBot
  class ThreadAction
    class << self
      def every_minute_update_user_rate
        ActiveRecord::Base.connection_pool.with_connection do
          Thread.new do
            loop do
              execute_each_sec(ENV['SLEEP_SEC'].to_i) do
                puts 'start update_user_rate'
                update_user_rate
                puts 'finish update_user_rate'
              end
            end
          end
        end
      end

      def every_hour_update_season_id
        Thread.new do
          loop do
            execute_each_sec(3600) do
              puts 'start feach_season'
              PUBGApi.feach_season
              puts "finish feach_season #{PUBGApi.season_id}"
            end
          end
        end
      end

      private
      def update_user_rate
        User.find_each(batch_size: 5) do |user|
          Table.check_rate_difference_and_create(user)
        end
      end

      def execute_each_sec(sleep_sec)
        yield
        sleep sleep_sec
      end
    end
  end
end