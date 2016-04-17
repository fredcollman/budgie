require 'rails_helper'

describe 'layouts/_flash.html.erb' do
	it 'shows an error if something went wrong' do
		flash.now[:error] = "oh dear"
		render
		expect(rendered).to have_css('.error')
	end

	it 'shows a success message if there is one' do
		flash.now[:success] = "hooray"
		render
		expect(rendered).to have_css('.success')
	end
end
