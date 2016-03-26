When(/^I upload a \.txt file from Santander$/) do
  @stream = SantanderTxtReader.from_file('features/support/santander.txt')
end

Then(/^the most recent transactions should be displayed$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
