require 'rails_helper'

describe 'home/show.html.erb' do
	it 'shows a message if there are no entries' do
		assign(:entries, [])
		render
		expect(rendered).to have_content("No Transactions")
	end
end
