When(/^I create a tag "([^"]*)"$/) do |tag|
  visit '/tags/new'
  fill_in 'tag-name', with: tag
  fill_in 'tag-description', with: 'A tag for testing'
  click_button 'Save'
end

Then(/^I am taken to the "([^"]*)" tag page$/) do |tag|
  pending # Write code here that turns the phrase above into concrete actions
end
