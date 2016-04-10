def santander_upload
	visit '/upload'
	page.attach_file('transaction_file', Rails.root + 'features/support/santander.txt')
	click_button 'Upload'
end

Given(/^I have previously uploaded santander.txt$/) do
	santander_upload
end

When(/^I upload santander.txt$/) do
	santander_upload
end

Then(/^the most recent transaction should be displayed first$/) do
	expect(page).to have_css('tr:first-child', 'BANK GIRO CREDIT REF WORK')
end

Then(/^0 transactions should be uploaded$/) do
	expect(page).to have_content('Uploaded 0 transactions')
end
