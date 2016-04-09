require 'rails_helper'

describe 'home/show.html.erb' do
	it 'shows transactions if there are any' do
		assign(:transactions, [build(:transaction, description: "visible")])
		render
		expect(rendered).to have_content("visible")
	end

	it 'shows multiple transactions' do
		assign(:transactions, build_list(:transaction, 3))
		render
		expect(rendered).to have_css("td.amount", count: 3)
	end

	it 'shows a message if there are no transactions' do
		assign(:transactions, [])
		render
		expect(rendered).to have_content("No transactions")
	end

	it 'formats money correctly' do
		assign(:transactions, [build(:transaction, amount: -123)])
		render
		expect(rendered).to have_css(".amount", text: "-£123.00")
	end

	it 'formats the date correctly' do
		assign(:transactions, [build(:transaction, date: Date.new(1999, 12, 31))])
		render
		expect(rendered).to have_content("31 Dec 1999")
	end

	it 'displays the balance' do
		assign(:transactions, [build(:transaction, balance: 567.89)])
		render
		expect(rendered).to have_content("£567.89")
	end
end
