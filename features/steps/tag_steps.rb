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

Given(/^I am on the page for the "([^"]*)" tag$/) do |tag|
  Tag.create! name: tag, description: 'Cucumber test tag'
  visit "/tags/#{tag}"
end

When(/^I click the delete button$/) do
  click_button 'Delete'
end

Then(/^the "([^"]*)" tag is no longer displayed$/) do |tag|
  expect(page).not_to have_content(tag)
end
