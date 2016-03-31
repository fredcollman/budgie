require 'capybara/cucumber'
require 'capybara/rails'

Capybara.register_driver :selenium_w10 do |app|
	Capybara::Selenium::Driver.new(app, browser: :remote, url: 'http://192.168.1.153:4444/wd/hub')
end

Capybara.default_driver = :selenium_w10
