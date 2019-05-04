module PUBGRateBot
  class GruffCreator
    def initialize(server_id, mode)
      @server_id = server_id
      @mode_id   = convert_to_mode_id(mode)
      @path      = "image/#{@server_id}/day/#{@mode_id}"
      @gruff = Gruff::Line.new
    end

    def create_day_gruff
      @gruff.title = "Day Rate"

      @gruff.write %{#{@path}/#{Date.today.to_s}.png}
    end

    def create_week_gruff(date)
      @gruff.title = "Week Rate"

      @gruff.write %{#{@path}/#{Date.today.to_s}.png}
    end

    def create_season_gruff(season_id)
      @gruff.title = "Season Rate"

      @gruff.write %{#{@path}/#{season_id}.png}
    end

    def create_total_gruff
      @gruff.title = "Total Rate"

      @gruff.write %{#{@path}/total.png}
    end

    private
    def convert_to_mode_id(mode)
      case mode
      when "solo"
        1
      when "solo-fpp"
        2
      when "duo"
        3
      when "duo-fpp"
        4
      when "squad"
        5
      when "squad-fpp"
        6
      else
        nil
      end
    end
  end
end
