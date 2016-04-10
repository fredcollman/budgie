require_relative '../../app/services/santander_txt_tailer'

describe SantanderTxtTailer do
	it 'converts lines to transactions' do
		tailer = SantanderTxtTailer.new([
			'Balance: 8366.61',
			'Amount: 1500.00',
			'Description: something',
			'Date: 24/03/2016',
		])
		expect(tailer.next).to eq SantanderTxtTailer::SantanderTransaction.new(
			Date.new(2016, 03, 24),
			'something',
			1500.00,
			8366.61
		)
	end

	it 'ignores irrelevant lines' do
		tailer = SantanderTxtTailer.new([
			'Description: ignore',
			'Date: 24/03/2016',
			'',
			'Balance: 8366.61',
			'Amount: 1500.00',
			'Description: something',
			'Date: 24/03/2016',
		])
		expect(tailer.next.description).to eq 'something'
	end

	it 'errors if transaction is incomplete' do
		expect {
			SantanderTxtTailer.new([
				'Balance: 8366.61',
				'Amount: 1500.00',
				'Description: something',
			]).next
		}.to raise_error(TransactionParseError)
	end

	it 'errors if transaction is invalid' do
		expect {
			SantanderTxtTailer.new([
				'Balance: 8366.61',
				'Amount: 100.00',
				'not a description',
				'Date: 24/03/2016',
			]).next
		}.to raise_error(TransactionParseError)
	end

	it 'allows iterating over all transactions' do
		tailer = SantanderTxtTailer.new([
			'Balance: 1100.00',			
			'Amount: 1500.00',
			'Description: older',
			'Date: 23/03/2016',
			'',
			'Balance: 1000.00',
			'Amount: -100.00',
			'Description: newer',
			'Date: 24/03/2016',
		])
		expect(tailer.map(&:description)).to eq ['older', 'newer']
	end

	it 'allows iterating with a block' do
		tailer = SantanderTxtTailer.new([
			'Balance: 1100.00',			
			'Amount: 1500.00',
			'Description: older',
			'Date: 23/03/2016',
			'',
			'Balance: 1000.00',
			'Amount: -100.00',
			'Description: newer',
			'Date: 24/03/2016',
		])
		amounts = []
		tailer.each { |t| amounts << t.amount }
		expect(amounts).to eq [1500.00, -100]
	end

	it 'throws if going beyond end of iteration' do
		expect {
			SantanderTxtTailer.new([]).next
		}.to raise_error(StopIteration)
	end
end
