require 'rspec'
require 'factory_girl'

require 'bezebe-cvs'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
    config.color_enabled = true
    config.formatter = 'documentation' if config.formatters.nil? || config.formatters.empty?
end

FactoryGirl.find_definitions