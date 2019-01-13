module command
  def setting
    bot.command :init do |event|
      Table.init_server event.server.id
    end

    bot.command :add do |event, pubg_name|
      Table.add_user_id_to_db(event, pubg_name)
    end

    bot.command :rate do |event, pubg_name|
      Table.get_rate_from_db(event, pubg_name)
    end

    bot.command :create_day do |event, date = nil|
      CreateGruff.create_today(event, date)
    end

    bot.command :create_week do |event|
      CreateGruff.create_week(event)
    end

    bot.command :create_week do |event|
      CreateGruff.create_week(event)
    end

    bot.command :create_total do |event|
      CreateGruff.create_total(event)
    end
  end
end