require 'active_support/logger'

module SexyScopesSpec
  extend self
  
  DEFAULT_DATABASE_SYSTEM = 'sqlite3'
  
  def connection_config
    config[database_system]
  end
  
  def database_system
    ENV['DB'] || DEFAULT_DATABASE_SYSTEM
  end
  
  def connect
    puts "Connecting using #{database_system}"
    ActiveRecord::Base.logger = ActiveSupport::Logger.new("debug.log", 0, 10 * 1024 * 1024)
    ActiveRecord::Base.establish_connection connection_config
  end
end
