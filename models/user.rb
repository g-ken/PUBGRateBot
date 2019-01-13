class User < ActiveRecord::Base
  has_and_belongs_to_many :servers
  has_many :rates
end