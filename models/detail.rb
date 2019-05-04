class Detail < ActiveRecord::Base
  belongs_to :user

  after_create do
    self.create_user(created_at: Date.today)
  end
end
