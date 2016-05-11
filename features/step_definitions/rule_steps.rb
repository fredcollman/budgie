Given(/^there is an active rule which tags all new entries with "([^"]*)"$/) do |to_add|
  visit '/'
  click_link 'Rules'
  click_link 'New'
  fill_in 'rule[name]', with: 'match all'
  fill_in 'rule[matching_regex]', with: '.*'
  select 'Add tag', from: 'rule[rule_type]'
  fill_in 'rule[tag_name]', with: to_add
  click_button 'Add'
end

Then(/^the most recent entry should be tagged with "([^"]*)"$/) do |tag|  
	expect(page).to have_css('tr:first-child .tag', tag)
end
