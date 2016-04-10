require_relative '../../app/services/santander_txt_reader'

describe SantanderTxtReader do
	it 'converts lines to transactions' do
		transactions = SantanderTxtReader.from_lines([
			'Date: 24/03/2016',
			'Description: something',
			'Amount: 1500.00',
			'Balance: 8366.61',
		])
		expect(transactions.next).to eq SantanderTransaction.new(
			Date.new(2016, 03, 24),
			'something',
			1500.00,
			8366.61
		)
	end

	it 'ignores irrelevant lines' do
		transactions = SantanderTxtReader.from_lines([
			'Amount: 1200.00',
			'Balance: 999.99',
			'',
			'Date: 24/03/2016',
			'Description: something',
			'Amount: 1500.00',
			'Balance: 8366.61',
		])
		expect(transactions.next.amount).to eq 1500.00
	end

	it 'errors if transaction is incomplete' do
		expect {
			SantanderTxtReader.from_lines([
				'Date: 24/03/2016',
				'Description: incomplete',
			]).next
		}.to raise_error(TransactionParseError)
	end

	it 'errors if transaction is invalid' do
		expect {
			SantanderTxtReader.from_lines([
				'Date: 24/03/2016',
				'not a description',
				'Amount: 100.00'
			]).next
		}.to raise_error(TransactionParseError)
	end

	it 'allows iterating over all transactions' do
		transactions = SantanderTxtReader.from_lines([
			'Date: 24/03/2016',
			'Description: newer',
			'Amount: -100.00',
			'Balance: 1000.00',
			'',
			'Date: 23/03/2016',
			'Description: older',
			'Amount: 1500.00',
			'Balance: 1100.00',			
		])
		expect(transactions.map(&:description)).to eq ['newer', 'older']
	end

	it 'allows iterating with a block' do
		transactions = SantanderTxtReader.from_lines([
			'Date: 24/03/2016',
			'Description: newer',
			'Amount: -100.00',
			'Balance: 1000.00',
			'',
			'Date: 23/03/2016',
			'Description: older',
			'Amount: 1500.00',
			'Balance: 1100.00',			
		])
		amounts = []
		transactions.each { |t| amounts << t.amount }
		expect(amounts).to eq [-100.00, 1500.00]
	end

	it 'throws if going beyond end of iteration' do
		expect {
			SantanderTxtReader.from_lines([]).next
		}.to raise_error(StopIteration)
	end
end
