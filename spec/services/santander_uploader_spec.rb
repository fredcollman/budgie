require_relative '../../app/services/santander_uploader'

describe SantanderUploader do
	it 'parses the file' do
		file = File.new('spec/support/santander.txt')
		expect(SantanderUploader.upload(file).map(&:description)).to eq([
			'BANK GIRO CREDIT REF WORK LTD',
			'CARD PAYMENT TO ONLINE,14.95 GBP, RATE 1.00/GBP ON 21-03-2016',
			'CARD PAYMENT TO SUPERMARKET,12.45 GBP, RATE 1.00/GBP ON 21-03-2016',
			'BILL PAYMENT TO ALICE REFERENCE THINGS',
			'CARD PAYMENT TO Amazon',
		].reverse)
	end
end