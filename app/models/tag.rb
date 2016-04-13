class Tag < ActiveRecord::Base
	has_many :taggings
	has_many :entries, through: :taggings

	validates :name, 
		presence: true, 
		uniqueness: true, 
		length: { maximum: 30 }

	default_scope {
		order(name: :asc)
	}

	def self.names
		pluck(:name)
	end

	def to_param
		name.parameterize
	end

	def self.remove!(name)
		Tag.find_by_name(name).destroy!
	end

	def self.find_or_create!(name)
		tag = find_by_name(name)
		if tag
			tag
		else
			create!(name: name)
		end
	end

	def recent_entries(count)
		entries.most_recent(count)
	end
end
