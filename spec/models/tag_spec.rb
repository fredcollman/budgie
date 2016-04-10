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
		Tag.create!(name: 'pickle')
		expect(Tag.names).to eq(['pickle'])
	end

	it 'can be converted to a slug' do
		tag = Tag.new(name: 'will be used', description: 'ignored')
		expect(tag.to_param).to eq 'will-be-used'
	end
end