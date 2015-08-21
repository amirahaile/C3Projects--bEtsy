require "simplecov"
require 'factory_girl'
require "rails_helper"
require "webmock/rspec"

SimpleCov.start do
  add_filter 'spec/'
end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.include Rails.application.routes.url_helpers
  Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
