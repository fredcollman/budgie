require 'rails_helper'

describe Entry do
	context :create! do
		it 'stores entries' do
			Entry.create!(date: Date.today, description: "hello", amount: 123.45)
			expect(Entry.first.description).to eq("hello")
		end

		[:date, :description, :amount].each do |required|
			it "checks the #{required} is present" do
				expect {
					Entry.create!(attributes_for(:entry, required => nil))
				}.to raise_error(ActiveRecord::RecordInvalid)
			end
		end

		it 'may include a balance' do
			Entry.create!(date: Date.today, description: "balance", amount: 0.01, balance: 5.00)
			expect(Entry.first.balance).to eq 5.00
		end
	end

	context :insert_many! do
		it 'allows bulk insert' do
			Entry.insert_many!(build_list(:entry, 5))
			expect(Entry.count).to eq(5)
		end

		it 'is optimized for bulk insert' do
			expect(Entry).to receive(:transaction).once
			Entry.insert_many!(build_list(:entry, 3))
		end

		it 'fails to create an invalid object' do
			expect {
				Entry.insert_many!(["nope"])
			}.to raise_error(Exception)
		end

		it 'validates the object' do
			begin
				Entry.insert_many!([build(:entry, amount: nil)])
			rescue Exception
			end
			expect(Entry.count).to eq 0
		end

		it 'errors if validation fails' do
			expect {
				Entry.insert_many!([build(:entry, amount: nil)])
			}.to raise_error(ActiveRecord::RecordInvalid)
		end

		it 'includes the balance' do
			Entry.insert_many!([build(:entry, balance: 300.01)])
			expect(Entry.first.balance).to eq 300.01
		end

		it 'returns the number of entries inserted' do
			result = Entry.insert_many!(build_list(:entry, 3))
			expect(result[:inserted]).to eq 3
		end
	end

	context :most_recent do
		it 'fetches entries' do
			create(:entry, description: "me")
			expect(Entry.most_recent(1).first.description).to eq("me")
		end

		it 'returns the specified number of results' do
			create_list(:entry, 3)
			expect(Entry.most_recent(2).size).to eq(2)
		end

		it 'fetches the most recent entries' do
			create(:entry, date: Date.new(2016, 1, 1))
			create(:entry, date: Date.new(2015, 1, 1))
			create(:entry, date: Date.new(2016, 2, 1))
			expect(Entry.most_recent(2).map(&:date)).to eq([
				Date.new(2016, 2, 1),
				Date.new(2016, 1, 1)
			])
		end

		it 'returns fewer results if there are not enough' do
			create(:entry)
			expect(Entry.most_recent(100).size).to eq(1)
		end

		it 'returns an empty array if there are no results' do
			expect(Entry.most_recent(5)).to eq([])
		end

		context 'for entries on the same day' do
			def create_with_description(description)
				create(:entry, date: Date.new(2016, 1, 1), description: description)
			end

			it 'fetches the most recently inserted entries' do
				in_order = ['first', 'second', 'third', 'fourth']
				in_order.each do |desc|
					create_with_description(desc)
				end
				expect(Entry.most_recent(4).map(&:description)).to eq(in_order.reverse)
			end
		end
	end

	context 'uniqueness' do
		let(:t1) { build(:entry,
			description: 'copied',
			date: Date.new(2016, 01, 01),
			amount: 500.00,
			balance: 1000.00
		)}
		let(:t2) { build(:entry,
			description: 'copied',
			date: Date.new(2016, 01, 01),
			amount: 500.00,
			balance: 1000.00
		)}

		it 'permits distinct entries' do
			create(:entry, description: 'one')
			create(:entry, description: 'two')
			expect(Entry.count).to eq 2
		end

		it 'prevents duplicate entries in separate transactions' do
			t1.save!
			expect {
				t2.save!
			}.to raise_error(ActiveRecord::RecordInvalid)
		end

		it 'permits duplicate descriptions on different dates' do
			t1.date = Date.new(2016, 01, 01)
			t2.date = Date.new(2016, 01, 02)
			t1.save!
			t2.save!
			expect(Entry.count).to eq 2
		end

		it 'permits duplicate descriptions with different balances' do
			t1.balance = 500.00
			t2.balance = 600.00
			t1.save!
			t2.save!
			expect(Entry.count).to eq 2
		end

		context 'when bulk inserting' do
			it 'ignores duplicate entries' do
				t3 = build(:entry, description: 'other')
				t1.save!
				Entry.insert_many!([t2, t3])
				expect(Entry.count).to eq 2
			end

			it 'returns the number of entries skipped' do
				result = Entry.insert_many!([t1, t2])
				expect(result[:skipped]).to eq 1
			end

			it 'does not count skipped entries as inserts' do
				result = Entry.insert_many!([t1, t2])
				expect(result[:inserted]).to eq 1
			end
		end
	end

	context '.tag_with' do
		before :each do
			allow(Tag).to receive_messages(find_or_create!: build(:tag))
		end

		it 'finds or creates the tag' do
			e = build(:entry)
			expect(Tag).to receive(:find_or_create!).with('banana')
			e.tag_with('banana')
		end

		it 'tags the entry' do
			e = build(:entry)
			expect {
				e.tag_with('something')
			}.to change(e.tags, :size).by(1)
		end
	end
end
