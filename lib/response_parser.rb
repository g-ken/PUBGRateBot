require "json"

module PUBGRateBot
  module ResponseParser
    class << self
      # レスポンスからレートを抜き出す
      # @param [Object] response <HTTP::Message>
      # @return [Array] [solo, solo-fpp, duo, duo-fpp, squad, squad-fpp]
      def extract_rank_point(response)
        json = convert_to_json(response)
        [
          find_rank_point(json, "solo"),
          find_rank_point(json, "solo-fpp"),
          find_rank_point(json, "duo"),
          find_rank_point(json, "duo-fpp"),
          find_rank_point(json, "squad"),
          find_rank_point(json, "squad-fpp"),
        ]
      end

      # レスポンスからアカウントIDを抜き出す
      # @param [Object] response <HTTP::Message>
      # @return [String] アカウントID
      def extract_account_id(response)
        json = convert_to_json(response)
        find_account_id(json)
      end

      # レスポンスからシーズンIDを抜き出す
      # @param [Object] response <HTTP::Message>
      # @return [String] シーズンID
      def extract_season_id(response)
        json = convert_to_json(response)
        find_current_season_id(json)
      end

      private
      # JSONレスポンスをHashに変換する
      # @param [Object] response <HTTP::Message>
      # @return [Hash]
      def convert_to_json(response)
        JSON.parse(response.body)
      end

      # Hashから指定されたモードのレートを抜き出す
      # @param [Hash] json
      # @param [String] mode
      # @return [String] レート
      def find_rank_point(json, mode)
        json.dig("data", "attributes", "gameModeStats", mode, "rankPoints")
      end

      # HashからアカウントIDを抜き出す
      # @param [Hash] json
      # @return [String] アカウントID
      def find_account_id(json)
        json.dig("data", 0, "id")
      end

      # HashからシーズンIDを抜き出す
      # @param [Hash] json
      # @return [String] シーズンID
      def find_current_season_id(json)
        json.dig("data", -1, "id")
      end
    end
  end
end
