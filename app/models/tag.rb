class Tag < ActiveRecord::Base
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
end
