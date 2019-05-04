require_relative 'table_controller'
require_relative 'rank_point_job'
module PUBGRateBot
  class JobRunner
    class << self
      def update_rate_job
        Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            loop do
              RankPointJob.new.update_rate
            end
          end
        end
      end
    end
  end
end
