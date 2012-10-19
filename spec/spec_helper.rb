require 'rspec'
require 'bezebe-cvs'

RSpec.configure do |config|
    config.color_enabled = true
    config.formatter = 'documentation' if config.formatters.nil? || config.formatters.empty?
end
