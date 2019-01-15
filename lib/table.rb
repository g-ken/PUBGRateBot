require 'active_record'
require 'date'
require_relative '../models/server'
require_relative '../models/server_user'
require_relative '../models/user'
require_relative '../models/rate'
require_relative './pubg_api'

module PUBGRateBot
  class Table
    class << self
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
          unless exists_relational_user?(server, pubg_name)
            server.users << User.find_by(name: pubg_name)
          end
        else
          player_id  =  PUBGApi.feach_player_state(pubg_name)
          unless player_id.nil?
            user       =  server.users.create({name: pubg_name, player_id: player_id, create_at: Date.today})
            add_rate(user)
          end
          nil
        end
      end

      def add_rate(user)
        data       =  PUBGApi.feach_player_season_state(user.player_id)
        data.each_value.with_index(1) do |a_data, index|
          user.rates.create(rate: a_data, mode_id: index, create_at: Date.today)
        end
      end 

      def get_rate(server_id, pubg_name, embed)
        user = Server.find_by(server_id: server_id).users.find_by(name: pubg_name)
        retrieve_user_rate(user, embed)
      end

      def check_rate_difference_and_create(user)
        rates = PUBGApi.feach_player_season_state(user.player_id)
        rates.each_value.with_index(1) do |rate, index|
          puts "#{user.name}'s rate  #{rate.to_i} == #{user.rates.where(["create_at = ? and mode_id = ?", Date.today, index]).last.rate} = #{rate.to_i == user.rates.where(["create_at = ? and mode_id = ?", Date.today, index]).last.rate}"
          user.rates.create(rate: rate, mode_id: index, create_at: Date.today) unless rate == user.rates.where(["create_at = ? and mode_id = ?", Date.today, index]).last
        end
      end

      private
      def exists_relational_user?(server, pubg_name)
        return server.users.exists?(name: pubg_name)
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