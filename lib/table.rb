require_relative '../models/server'
require_relative '../models/server_user'
require_relative '../models/user'
require_relative 'pubgapi'
module Table
  class << self
    def create(database_name)
      unless File.exist?(database_name)
        ActiveRecord::Migration.create_table :servers do |t|
          t.string :server_id
        end

        ActiveRecord::Migration.create_table :servers_users do |t|
          t.belongs_to :server, index: true
          t.belongs_to :user, index: true
        end

        ActiveRecord::Migration.create_table :users do |t|
          t.string :name
          t.string :player_id
          t.timestamps
        end

        ActiveRecord::Migration.create_table :rates do |t|
          t.belongs_to :user, index: true
          t.integer :rate
          t.integer :mode_id
          t.timestamps
        end

        ActiveRecord::Migration.create_table :discord do |t|
          t.belongs_to :user, index: true
          t.string :discord_id
        end
      end
    end

    def init_server(server_id)
      server = Server.find_or_initialize_by(server_id: server_id)
      server.update_attributes(
        server_id:  server_id
      )
    end

    def add_user_id_to_db(server_id, name)
      server = Server.find_or_initialize_by(server_id: server_id)
      server.users.create({name: name})
    end
  end
end