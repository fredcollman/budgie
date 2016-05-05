class Rule < ActiveRecord::Base
	def rule_type
		"Add tag"
	end

	def self.types
		[["Add tag", 1]]
	end
end
