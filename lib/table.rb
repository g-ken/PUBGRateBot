require 'active_record'
require_relative '../models/server'
require_relative '../models/server_user'
require_relative '../models/user'
require_relative './pubg_api'
require_relative './shape'

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

          ActiveRecord::Migration.create_table :discord do |t|
            t.belongs_to :user, index: true
            t.string :discord_id
          end
        end
      end

      def add_user(server_id, pubg_name)
        server = Server.find_or_create_by(server_id: server_id)
        server.update_attributes(server_id: server_id)
        unless exist_relational_user?(server, pubg_name)
          data       =  PUBGApi.feach_player_state(pubg_name)
          player_id  =  Shape.extract_account_id(data)
          server.users.create({name: pubg_name, player_id: player_id})
        end
      end

      def add_rate(server_id, pubg_name)

      end

      private
      def exist_relational_user?(server, pubg_name)
        return server.users.exists?(name: pubg_name)
      end
    end
  end
end