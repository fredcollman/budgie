When(/^I upload a \.txt file from Santander$/) do
	visit '/upload'
	page.attach_file('transaction_file', Rails.root + 'features/support/santander.txt')
	click_button 'Upload'
end

Then(/^the most recent transactions should be displayed$/) do
	expect(page).to have_content('BANK GIRO CREDIT REF WORK')
end
