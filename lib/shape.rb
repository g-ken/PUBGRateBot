module PUBGRateBot
  class Shape
    class << self
      def extract_rate_hash(res)
        data = JSON.parse(res.body)
        return {
          "solo":      data["data"]["attributes"]["gameModeStats"]["solo"]["rankPoints"],
          "solo-fpp":  data["data"]["attributes"]["gameModeStats"]["solo-fpp"]["rankPoints"],
          "duo":       data["data"]["attributes"]["gameModeStats"]["duo"]["rankPoints"],
          "duo-fpp":   data["data"]["attributes"]["gameModeStats"]["duo-fpp"]["rankPoints"],
          "squad":     data["data"]["attributes"]["gameModeStats"]["squad"]["rankPoints"],
          "squad-fpp": data["data"]["attributes"]["gameModeStats"]["squad-fpp"]["rankPoints"],
        }
      end

      def extract_account_id(res)
        return JSON.parse(res.body)["data"].first["id"]
      end
      
      def extract_season_id(res)
        return JSON.parse(res.body)["data"].last["id"]
      end
    end
  end
end