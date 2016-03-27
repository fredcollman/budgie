When(/^I upload a \.txt file from Santander$/) do
  @stream = SantanderTxtReader.from_file(File.new('features/support/santander.txt').set_encoding('utf-8'))
  @stream.each.map { |m| puts "#{m.date} #{m.amount} #{m.description}" }
end

Then(/^the most recent transactions should be displayed$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
