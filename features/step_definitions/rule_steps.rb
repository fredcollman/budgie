Given(/^there is an active rule which tags all new entries with "([^"]*)"$/) do |to_add|
  visit '/'
  click_link 'Rules'
  click_link 'New'
  fill_in 'rule[name]', with: 'match all'
  fill_in 'rule[regex]', with: '.*'
  select 'Add tag', from: 'rule[type]'
  fill_in 'rule[tag_name]', with: to_add
  click_button 'Add'
end

Then(/^the most recent entry should be tagged with "([^"]*)"$/) do |tag|  
	within 'tr:first-child' do
		expect(page).to have_css('.tag', tag)
	end
end
