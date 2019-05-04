require_relative '../lib/table_controller'
module PUBGRateBot
  class RankPointJob
    def initialize
      @table_controller = TableController.new(season: true)
      @wait = calculate_wait
    end

    def update_rate
      User.all.each do |user|
        @table_controller.user = user
        @table_controller.register_user_rank_points
        p @table_controller.user
        sleep(@wait)
      end
    end

    def calculate_wait
      case User.count
      when 0
        60
      when 1..4
        16
      when 5..9
        13
      when 10..Float::INFINITY
        8
      else
        60
      end
    end
  end
end
