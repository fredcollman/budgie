require 'rails_helper'

describe Rule do
	it 'has a type' do
		expect(Rule.new.rule_type).to eq "Add tag"
	end

	it 'knows all possible rule types' do
		expect(Rule.types).to eq [["Add tag", 1]]
	end

	context 'when the regex matches' do
		it 'tags an entry' do
			entry = build(:entry)
			orange_rule = Rule.new(name: 'orange rule', matching_regex: '.*', tag_name: 'orange')
			expect(entry).to receive(:tag_with).with('orange')
			orange_rule.apply_to(entry)
		end

		it 'returns an entry' do
			entry = build(:entry, description: 'some description')
			orange_rule = Rule.new(name: 'orange rule', matching_regex: '.*', tag_name: 'orange')
			response = orange_rule.apply_to(entry)
			expect(response.description).to eq 'some description'
		end
	end

	context 'when the regex does not match' do
		let(:rule) { Rule.new(name: 'nope', matching_regex: 'nomatch', tag_name: 'irrelevant') }

		it 'does nothing' do
			entry = double('no other messages', description: 'something')
			rule.apply_to(entry)
		end

		it 'returns an entry' do
			entry = build(:entry, description: 'something')
			expect(rule.apply_to(entry)).to eq entry
		end
	end
end
