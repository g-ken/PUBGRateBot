# class CreateTable < ActiveRecord::Base
#   #ＤＢがなければ作成
#   class << self
#     def create(database_name)
#       unless File.exist?(database_name)
#         ActiveRecord::Migration.create_table :servers do |t|
#           t.string :server_id
#         end
# 
#         ActiveRecord::Migration.create_table :server_user do |t|
#           t.belongs_to :server, index: true
#           t.belongs_to :user, index: true
#         end
# 
#         ActiveRecord::Migration.create_table :users do |t|
#           t.string :name
#           t.string :player_id
#           t.timestamps
#         end
# 
#         ActiveRecord::Migration.create_table :rates do |t|
#           t.belongs_to :user, index: true
#           t.integer :rate
#           t.integer :mode_id
#           t.timestamps
#         end
# 
#         ActiveRecord::Migration.create_table :discord do |t|
#           t.belongs_to :user, index: true
#           t.string :discord_id
#         end
#       end
#     end
#   end
# end