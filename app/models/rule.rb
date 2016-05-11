class Rule < ActiveRecord::Base
	def rule_type
		"Add tag"
	end

	def self.types
		[["Add tag", 1]]
	end

	def apply_to(entry)
		if entry.description =~ Regexp.new(matching_regex)
			entry.tag_with(tag_name)
		end
		entry
	end
end
