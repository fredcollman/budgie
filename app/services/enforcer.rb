class Enforcer
	def self.enforce(rules, entries, &block)
		entries.map do |entry|
			rules.reduce(entry) do |current_entry, rule| 
				rule.apply_to(current_entry)
			end
		end
	end
end
