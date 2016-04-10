Given(/^I am on the home page$/) do
  visit '/'
end

When(/^I create a tag "([^"]*)"$/) do |tag|
	click_link 'Tags'
	click_link 'New'
  fill_in 'tag[name]', with: tag
  fill_in 'tag[description]', with: 'A tag for testing'
  click_button 'Save'
end

Then(/^I am taken to the "([^"]*)" tag page$/) do |tag|
  expect(page).to have_css('h1', tag)
end
