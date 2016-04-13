require 'rails_helper'

describe Tag do
	context 'name' do
		it 'cannot be blank' do
			expect(Tag.new(name: nil)).to be_invalid
			expect(Tag.new(name: '')).to be_invalid
		end

		it 'must be unique' do
			Tag.create!(name: 'duplicate')
			expect {
				Tag.create!(name: 'duplicate')
			}.to raise_error(ActiveRecord::RecordInvalid)
		end

		it 'cannot be too long' do
			expect(Tag.new(name: 'a' * 30)).to be_valid
			expect(Tag.new(name: 'a' * 31)).to be_invalid
		end
	end

	it 'can have a description' do
		expect(Tag.new(name: 'required', description: 'optional')).to be_valid
	end

	it 'fetches tags in alphabetical order' do
		names = ['armadillo', 'cheese', 'bandwagon']
		names.each { |n| Tag.create!(name: n) }
		expect(Tag.all.map(&:name)).to eq(['armadillo', 'bandwagon', 'cheese'])
	end

	it 'can fetch just names' do
		create(:tag, name: 'pickle')
		expect(Tag.names).to eq(['pickle'])
	end

	it 'can be converted to a slug' do
		tag = build(:tag, name: 'will be used')
		expect(tag.to_param).to eq 'will-be-used'
	end

	context '.remove' do
		it 'deletes the tag' do
			create(:tag, name: 'mytag')
			expect {
				Tag.remove!('mytag')
			}.to change(Tag, :count).by(-1)
		end
	end

	context '.find_and_create!' do
		it 'finds the tag if it exists' do
			tag = create(:tag, name: 'exists')
			expect(Tag.find_or_create!('exists')).to eq tag
		end

		it 'creates the tag if it does not exist' do
			expect {
				Tag.find_or_create!('not here')
				}.to change(Tag, :count).by(1)
		end
	end

	it 'can fetch entries tagged with this tag' do
		tag = create(:tag, name: 'something')
		entries = create_list(:entry, 3, tags: [tag])
		expect(tag.entries.size).to eq 3
	end

	context :recent_entries do
		let (:tag) { create(:tag) }

		before do
			allow(Entry).to receive(:most_recent) do |n|
				Entry.all
			end
		end

		it 'fetches entries associated with this tag' do
			entry = create(:entry, tags: [tag])
			expect(tag.recent_entries(10)).to eq [entry]
		end

		it 'only fetches entries associated with this tag' do
			entry = create(:entry, tags: [])
			expect(tag.recent_entries(10)).to eq []
		end
	end
end
