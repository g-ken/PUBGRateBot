require 'active_record'
require 'date'
require_relative '../models/server'
require_relative '../models/server_user'
require_relative '../models/user'
require_relative '../models/rate'
require_relative './pubg_api'
require_relative './shape'
require_relative './queue'

module PUBGRateBot
  Table = Class.new do
    class << self
      log = Logger.new("./log/bot_log")
      def create(database_name)
        unless File.exist?(database_name)
          ActiveRecord::Migration.create_table :servers do |t|
            t.string :server_id
          end

          ActiveRecord::Migration.create_table :servers_users, id: false do |t|
            t.belongs_to :server, index: true
            t.belongs_to :user, index: true
          end

          ActiveRecord::Migration.create_table :users do |t|
            t.string :name
            t.string :player_id
            t.date :create_at
          end

          ActiveRecord::Migration.create_table :rates do |t|
            t.belongs_to :user, index: true
            t.integer :rate
            t.integer :mode_id
            t.date :create_at
          end

          ActiveRecord::Migration.create_table :discords do |t|
            t.belongs_to :user, index: true
            t.string :discord_id
          end
        end
      end

      def add_user(server_id, pubg_name)
        server = Server.find_or_create_by(server_id: server_id)
        server.update_attributes(server_id: server_id)
        if User.exists?(name: pubg_name)
          unless server.users.exists?(name: pubg_name)
            server.users << User.find_by(name: pubg_name)
            return "Success."
          else
            return "Already relational."
          end
        else
          data      = PUBGApi.feach_player_state(pubg_name)
          player_id = Shape.extract_account_id(data)
          unless player_id.nil?
            user = User.new(name: pubg_name, player_id: player_id, create_at: Date.today)
            if user.save
              server.users << user
              return "Success"
            else
              return "Faild. try again later."
            end
          else
            return "Not found player or limit request. Check name and try agein one minute later."
          end
        end
      end

      def get_rate(server_id, pubg_name, embed)
        user = Server.find_by(server_id: server_id).users.find_by(name: pubg_name)
        unless user.nil?
          return retrieve_user_rate(user, embed)
        else
          return "Not found player"
        end
      end

      def update_user_rate
        queue = Queue.new
        User.all.each do |user|
          queue.enqueue(user)
          puts "enqueue #{user.name}"
        end
        while !queue.empty? do
          user = queue.dequeue
          puts "feach #{user.name}"
          check_rate_difference_and_create(user)
          sleep(10)
        end
      end

      def check_rate_difference_and_create(user)
        data = PUBGApi.feach_player_season_state(user.player_id)
        rates = Shape.extract_rate_hash(check_response(data))
        unless rates.nil?
          rates.each_value.with_index(1) do |rate, index|
            user_rate = user.rates.where(["create_at = ? and mode_id = ?", Date.today, index])
            if user_rate.last.nil?
              user.rates.create(rate: rate, mode_id: index, create_at: Date.today)
            elsif rate.to_i != user_rate.last.rate.to_i
              user.rates.create(rate: rate, mode_id: index, create_at: Date.today)
            end
          end
        else
          queue.enqueue(user)
        end
      end

      private

      define_method :check_response do |data|
        case data.status
        when 200
          log.info('success')
          return data
        when 401
          log.warn('API key invalid or missing')
          return nil
        when 404
          log.warn('The specified resource was not found')
          return nil
        when 415
          log.warn('Content type incorrect or not specified')
          return nil
        when 429
          log.warn('Too many requests')
          return nil
        end
          
      end

      def retrieve_user_rate(user, embed)
        embed.title = "PUBG Rate"
        embed.colour = 0x00FFFF
        embed.description = "#{user.name}'s rate"
        embed.add_field(
          name: "TPP solo",
          value: "#{user.rates.where(mode_id: 1).last.rate}",
          inline: true
        )
        embed.add_field(
          name: "TPP duo",
          value: "#{user.rates.where(mode_id: 3).last.rate}",
          inline: true
        )
        embed.add_field(
          name: "TPP squad",
          value: "#{user.rates.where(mode_id: 5).last.rate}",
          inline: true
        )
        embed.add_field(
          name: "FPP solo",
          value: "#{user.rates.where(mode_id: 2).last.rate}",
          inline: true
        )
        embed.add_field(
          name: "FPP duo",
          value: "#{user.rates.where(mode_id: 4).last.rate}",
          inline: true
        )
        embed.add_field(
          name: "FPP squad",
          value: "#{user.rates.where(mode_id: 6).last.rate}",
          inline: true
        )
      end
    end
  end
end
