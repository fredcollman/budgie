require 'rails_helper'

describe 'upload/show.html.erb' do
	it 'has a file input box' do
		render

		expect(rendered).to have_css('input[type=file]')
	end

	it 'shows an error if upload failed' do
		flash.now[:error] = "oh dear"
		render

		expect(rendered).to have_css('.error')
	end
end
