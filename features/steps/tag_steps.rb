Given(/^I am on the home page$/) do
  visit '/'
end

Given(/^I am on the page for the "([^"]*)" tag$/) do |tag|
  Tag.create! name: tag, description: 'Cucumber test tag'
  visit "/tags/#{tag}"
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

Then(/^I am taken to the "([^"]*)" tag page$/) do |tag|
  expect(page).to have_css('h1', tag)
end

Then(/^the "([^"]*)" tag is no longer displayed$/) do |tag|
  expect(page).not_to have_css('.tag', tag)
  expect(page).to have_content("\"#{tag}\" has been deleted")
end

def complete_tag_form(params)
  fill_in 'tag[name]', with: params[:name]
  fill_in 'tag[description]', with: params[:description] if params[:description]
  click_button 'Save'
end
