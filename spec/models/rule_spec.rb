require 'rails_helper'

describe Rule do
	it 'has a type' do
		expect(Rule.new.rule_type).to eq "Add tag"
	end

	it 'knows all possible rule types' do
		expect(Rule.types).to eq [["Add tag", 1]]
	end
end
