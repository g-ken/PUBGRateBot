require_relative '../models/rate'
require_relative '../models/user'
require_relative '../models/mode'
class CreateTable < ActiveRecord::Base
  @modes = ["solo", "solo-fpp", "duo", "duo-fpp", "squad", "squad-fpp"]
  def self.create(database_name)
    unless File.exist?(database_name)
      ActiveRecord::Migration.create_table :rates do |t|
        t.integer :player_rate
        t.integer :user_id
        t.integer :mode_id
        t.timestamps
      end

      ActiveRecord::Migration.create_table :users do |t|
        t.string :player_name
        t.string :player_id
      end

      ActiveRecord::Migration.create_table :modes do |t|
        t.string :play_mode
      end
      
      @modes.each do | mode |
        Mode.new(play_mode: mode).save
      end
    end
  end
end