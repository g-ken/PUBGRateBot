class User < ActiveRecord::Base
  has_and_belongs_to_many :servers
  has_many :rank_points
  has_one :discord
  has_one :detail
end
