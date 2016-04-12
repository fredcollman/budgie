Given(/^I am on the home page$/) do
  visit '/'
end

Given(/^I am on the page for the "([^"]*)" tag$/) do |tag|
  Tag.create! name: tag, description: 'Cucumber test tag'
  visit "/tags/#{tag}"
end

Given(/^the "([^"]*)" tag exists$/) do |tag|
  Tag.create! name: tag, description: 'the tag exists'
end

Given(/^the transaction "([^"]*)" exists$/) do |description|
  Transaction.create! amount: 100.00, description: description, date: Date.today
end

When(/^I create a tag "([^"]*)"$/) do |tag|
  click_link 'Tags'
  click_link 'New'
  complete_tag_form name: tag
end

When(/^I click the delete button$/) do
  click_link 'Delete'
end

When(/^I rename the tag to "([^"]*)"$/) do |tag|
  click_link 'Edit'
  complete_tag_form name: tag
end

When(/^I tag the transaction "([^"]*)" with the tag "([^"]*)"$/) do |description, tag|
  find('.description', text: description).find('.new').click
  fill_in 'add-tag', with: tag
end

When(/^I go to the "([^"]*)" tag page$/) do |tag|
  visit "/tags/#{tag}"
end

Then(/^I am taken to the "([^"]*)" tag page$/) do |tag|
  expect(page).to have_css('h1', tag)
end

Then(/^the "([^"]*)" tag is no longer displayed$/) do |tag|
  expect(page).not_to have_css('.tag', tag)
  expect(page).to have_content("\"#{tag}\" has been deleted")
end

Then(/^I see the transaction "([^"]*)"$/) do |description|
  expect(page).to have_content(description)
end

def complete_tag_form(params)
  fill_in 'tag[name]', with: params[:name]
  fill_in 'tag[description]', with: params[:description] if params[:description]
  click_button 'Save'
end
