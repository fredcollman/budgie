require 'rails_helper'

describe 'home/show.html.erb' do
	it 'shows entries if there are any' do
		assign(:entries, [build(:entry, description: "visible")])
		render
		expect(rendered).to have_content("visible")
	end

	it 'shows multiple entries' do
		assign(:entries, build_list(:entry, 3))
		render
		expect(rendered).to have_css("td.amount", count: 3)
	end

	it 'shows a message if there are no entries' do
		assign(:entries, [])
		render
		expect(rendered).to have_content("No Transactions")
	end

	it 'formats money correctly' do
		assign(:entries, [build(:entry, amount: -123)])
		render
		expect(rendered).to have_css(".amount", text: "-£123.00")
	end

	it 'formats the date correctly' do
		assign(:entries, [build(:entry, date: Date.new(1999, 12, 31))])
		render
		expect(rendered).to have_content("31 Dec 1999")
	end

	it 'displays the balance' do
		assign(:entries, [build(:entry, balance: 567.89)])
		render
		expect(rendered).to have_content("£567.89")
	end
end
