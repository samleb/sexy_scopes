if ENV['COVERAGE'] || ENV['TRAVIS']
  require 'simplecov'

  if ENV['TRAVIS']
    require 'coveralls'
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  end

  SimpleCov.start do
    # exclude Gemfiles and gems bundled by Travis
    add_filter 'gemfiles/'
    add_filter 'spec/'
  end
end

require 'rspec'
require 'active_record'
require 'sexy_scopes'

Dir.glob(File.join(File.dirname(__FILE__), '{support,fixtures,matchers}', '*')) do |file|
  require file
end

RSpec.configure do |config|
  config.extend DatabaseSystemHelper
end
