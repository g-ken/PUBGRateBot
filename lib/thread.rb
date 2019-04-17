require_relative 'table'
require_relative 'pubg_api'
require_relative '../models/rate'
require_relative '../models/user'

module PUBGRateBot
  class ThreadAction
    class << self
      def five_minute_update_user_rate
        ActiveRecord::Base.connection_pool.with_connection do
          Thread.new do
            loop do
              Table.update_user_rate
            end
          end
        end
      end

      def every_hour_update_season_id
        Thread.new do
          loop do
            execute_each_sec(3600) do
              PUBGApi.feach_season
              puts "finish feach_season #{PUBGApi.season_id}"
            end
          end
        end
      end

      private
      def execute_each_sec(sleep_sec)
        yield
        sleep sleep_sec
      end
    end
  end
end
