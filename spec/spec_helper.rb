require 'rspec'
require 'factory_girl'

require 'bezebe-cvs'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
    config.color_enabled = true
end

FactoryGirl.find_definitions