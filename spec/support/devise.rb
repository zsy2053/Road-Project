require 'devise'
require Rails.root.join("spec/support/controller_macros.rb")

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, :type => :controller
  config.include Devise::Test::ControllerHelpers, :type => :view
  config.include ControllerMacros, :type => :controller
end
