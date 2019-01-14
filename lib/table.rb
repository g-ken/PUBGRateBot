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
          user       =  server.users.create({name: pubg_name, player_id: player_id, create_at: Date.today})
          add_rate(user)
        end
      end

      def add_rate(user)
        season_id  =  PUBGApi.feach_season
        data       =  PUBGApi.feach_player_season_state(user.player_id, season_id)
        data.each_value.with_index(1) do |a_data, index|
          user.rates.create(rate: a_data, mode_id: index, create_at: Date.today)
        end
      end 

      def get_rate(server_id, pubg_name)
        server = Server.find_by(server_id: server_id)
        server.users.find_by(name: pubg_name)
      end

      private
      def exists_relational_user?(server, pubg_name)
        return server.users.exists?(name: pubg_name)
      end
    end
  end
end