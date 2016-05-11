class ProcRule
	def initialize(&block)
		@proc = block
	end

	def apply_to(e)
		@proc.call(e)
	end
end

describe Enforcer do
	it 'enforces rules' do
		rule = instance_double('Rule')
		expect(rule).to receive(:apply_to).with('entry')
		Enforcer.enforce([rule], ['entry'])
	end

	it 'returns the original entries if there are no rules' do
		expect(Enforcer.enforce([], ['original', 'entries'])).to eq(['original', 'entries'])
	end

	it 'applies the rule to every entry' do
		rules = [ProcRule.new(&:length)]
		expect(Enforcer.enforce(rules, ['all', 'these', 'entries'])).to eq [3, 5, 7]
	end

	it 'applies every rule to the entries' do
		double_it = ProcRule.new { |e| 2 * e }
		add_three = ProcRule.new { |e| e + 3 }
		expect(Enforcer.enforce([double_it, add_three], [4])).to eq [2 * 4 + 3]
	end
end