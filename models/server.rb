class Server < ActiveRecord::Base
  has_and_belongs_to_many :users
  after_create :make_server_folder

  private
  def make_server_folder
    path = "image/#{self.server_id}"
    unless Dir.exist?(path)
      Dir.mkdir(path)
      %w{day week season total}.each do |category|
        Dir.mkdir("#{path}/#{category}")
        1.upto(6) do |mode_id|
          Dir.mkdir("#{path}/#{category}/#{mode_id}")
        end
      end
    end
  end
end
