require 'rails_helper'

describe Transaction do
	context :create! do
		it 'stores transactions' do
			Transaction.create!(date: Date.today, description: "hello", amount: 123.45)
			expect(Transaction.first.description).to eq("hello")
		end

		[:date, :description, :amount].each do |required|
			it "checks the #{required} is present" do
				expect {
					Transaction.create!(attributes_for(:transaction, required => nil))
				}.to raise_error(ActiveRecord::RecordInvalid)
			end
		end

		it 'may include a balance' do
			Transaction.create!(date: Date.today, description: "balance", amount: 0.01, balance: 5.00)
			expect(Transaction.first.balance).to eq 5.00
		end
	end

	context :insert_many! do
		it 'allows bulk insert' do
			Transaction.insert_many!(build_list(:transaction, 5))
			expect(Transaction.count).to eq(5)
		end

		it 'is optimized for bulk insert' do
			expect(Transaction).to receive(:transaction).once
			Transaction.insert_many!(build_list(:transaction, 3))
		end

		it 'fails to create an invalid object' do
			expect {
				Transaction.insert_many!(["nope"])
			}.to raise_error(Exception)
		end

		it 'validates the object' do
			begin
				Transaction.insert_many!([build(:transaction, amount: nil)])
			rescue Exception
			end
			expect(Transaction.count).to eq 0
		end

		it 'errors if validation fails' do
			expect {
				Transaction.insert_many!([build(:transaction, amount: nil)])
			}.to raise_error(ActiveRecord::RecordInvalid)
		end

		it 'includes the balance' do
			Transaction.insert_many!([build(:transaction, balance: 300.01)])
			expect(Transaction.first.balance).to eq 300.01
		end
	end

	context :most_recent do
		it 'fetches transactions' do
			create(:transaction, description: "me")
			expect(Transaction.most_recent(1).first.description).to eq("me")
		end

		it 'returns the specified number of results' do
			create_list(:transaction, 3)
			expect(Transaction.most_recent(2).size).to eq(2)
		end

		it 'fetches the most recent transactions' do
			create(:transaction, date: Date.new(2016, 1, 1))
			create(:transaction, date: Date.new(2015, 1, 1))
			create(:transaction, date: Date.new(2016, 2, 1))
			expect(Transaction.most_recent(2).map(&:date)).to eq([
				Date.new(2016, 2, 1),
				Date.new(2016, 1, 1)
			])
		end

		it 'returns fewer results if there are not enough' do
			create(:transaction)
			expect(Transaction.most_recent(100).size).to eq(1)
		end

		it 'returns an empty array if there are no results' do
			expect(Transaction.most_recent(5)).to eq([])
		end
	end

	context 'uniqueness' do
		let(:t1) { build(:transaction,
			description: 'copied',
			date: Date.new(2016, 01, 01),
			amount: 500.00,
			balance: 1000.00
		)}
		let(:t2) { build(:transaction,
			description: 'copied',
			date: Date.new(2016, 01, 01),
			amount: 500.00,
			balance: 1000.00
		)}

		it 'permits distinct transactions' do
			create(:transaction, description: 'one')
			create(:transaction, description: 'two')
			expect(Transaction.count).to eq 2
		end

		it 'prevents duplicate transactions in separate transactions' do
			t1.save!
			expect {
				t2.save!
			}.to raise_error(ActiveRecord::RecordInvalid)
		end

		it 'ignores duplicate transactions when bulk inserting' do
			t3 = build(:transaction, description: 'other')
			t1.save!
			Transaction.insert_many!([t2, t3])
			expect(Transaction.count).to eq 2
		end

		it 'permits duplicate descriptions on different dates' do
			t1.date = Date.new(2016, 01, 01)
			t2.date = Date.new(2016, 01, 02)
			t1.save!
			t2.save!
			expect(Transaction.count).to eq 2
		end

		it 'permits duplicate descriptions with different balances' do
			t1.balance = 500.00
			t2.balance = 600.00
			t1.save!
			t2.save!
			expect(Transaction.count).to eq 2
		end
	end
end
