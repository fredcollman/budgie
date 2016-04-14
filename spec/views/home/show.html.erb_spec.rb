require 'rails_helper'

describe 'home/show.html.erb' do
	it 'shows the no entries view when there are no entries' do
		assign(:entries, [])
		render
		assert_template partial: '_no_entries'
	end
end
