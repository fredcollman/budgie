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
end
