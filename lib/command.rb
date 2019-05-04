require_relative './create_gruff'
require_relative './table_controller'
require_relative './embed_creator'

module PUBGRateBot
  module Command
    class << self
      def add(server_id, player_name)
        table_controller = TableController.new
        table_controller.add_user(server_id, player_name)
        EmbedCreator.add_command(table_controller.user)
      end

      def rate(player_name)
        table_controller = TableController.new
        rank_points = table_controller.retrieve_rank_points(player_name)
        EmbedCreator.rate_command(table_controller.user, rank_points)
      end

      def day(server_id, mode)
        table_controller = TableController.new

      end
    end
  end
end
