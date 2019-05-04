class RankPoint < ActiveRecord::Base
  belongs_to :season
  belongs_to :user
end
