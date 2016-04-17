require_relative '../../app/services/santander_txt_parser'

describe SantanderTxtParser do
	context 'description' do
		def description_for(text)
			SantanderTxtParser.parse_description(text)
		end

		it 'extracts the description' do
			expect(description_for('Description: A transaction')).to eq 'A transaction'
		end

		it 'ignores irrelevant lines' do
			expect(description_for('Date: 24/03/2016')).to be_nil
		end

		it 'errors if description format is invalid' do
			expect {
				description_for('Description:INVALID_FORMAT')
			}.to raise_error(TransactionParseError)
		end

		it 'ignores leading whitespace' do
			desc = description_for("  \t Description: Something")
			expect(desc).to eq 'Something'
		end

		it 'ignores lines with irrelevant characters' do
			desc = description_for("some Description: no\nDescription: yes")
			expect(desc).to eq 'yes'
		end

		it 'ignores trailing whitespace' do
			desc = description_for("Description: trail  \n \n")
			expect(desc).to eq 'trail'
		end

		it 'ignores irrelevant lines' do
			desc = description_for("abc\nDescription: def\nghi")
			expect(desc).to eq 'def'
		end

		it 'handles non-standard whitespace' do
			desc = description_for("Description: non breaking spaces\n".gsub(/ /, "\u00a0"))
			expect(desc).to eq 'non breaking spaces'
		end
	end

	context 'amount' do
		def amount_for(text)
			SantanderTxtParser.parse_amount(text)
		end

		it 'extracts the amount' do
			amount = amount_for('Amount: 1.99')
			expect(amount).to eq 1.99
		end

		it 'extracts negative amounts' do
			amount = amount_for('Amount: -999.99')
			expect(amount).to eq -999.99
		end

		it 'errors if the amount is not a number' do
			expect {
				amount_for('Amount: bob')
			}.to raise_error(TransactionParseError)
		end
	end

	context 'date' do
		def date_for(text)
			SantanderTxtParser.parse_date(text)
		end

		it 'extracts the date' do
			date = date_for('Date: 31/12/1999')
			expect(date).to eq Date.new(1999, 12, 31)
		end

		it 'errors if the day is out of bounds' do
			expect {
				date_for('Date: 30/02/1999')
			}.to raise_error(TransactionParseError)
		end

		it 'errors if the year format is wrong' do
			expect {
				date_for('Date: 01/01/01')
			}.to raise_error(TransactionParseError)
		end
	end

	context 'balance' do
		def balance_for(text)
			SantanderTxtParser.parse_balance(text)
		end

		it 'extracts the balance' do
			balance = balance_for('Balance: 1.99')
			expect(balance).to eq 1.99
		end

		it 'extracts negative balances' do
			balance = balance_for('Balance: -999.99')
			expect(balance).to eq -999.99
		end

		it 'errors if the balance is not a number' do
			expect {
				balance_for('Balance: nope')
			}.to raise_error(TransactionParseError)
		end
	end
end
