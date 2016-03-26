require_relative "../../app/services/santander_txt_reader"

describe SantanderTxtReader do
	it 'converts lines to transactions' do
		transactions = SantanderTxtReader.from_lines([
			'Date: 24/03/2016',
			'Description: something',
			'Amount: 1500.00',
			'Balance: 8366.61',
		])
		allow(SantanderTxtParser).to receive_messages(
			parse_date: Date.new(2016, 03, 24),
			parse_description: 'something',
			parse_amount: 1500.00
		)
		expect(transactions.next.description).to eq 'something'
	end
end
