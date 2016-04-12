class Entry < ActiveRecord::Base
	validates :date, presence: true
	validates :description, presence: true
	validates :amount, presence: true
	validates :description, uniqueness: { scope: [:date, :balance] }

	def self.insert_many!(entries)
		transaction do 
			inserted = 0
			skipped = 0
			entries.each do |entry| 
				begin
					create!({
						date: entry.date,
						description: entry.description,
						amount: entry.amount,
						balance: entry.balance
					})
				rescue ActiveRecord::RecordInvalid => error
					raise error unless error.message == "Validation failed: Description has already been taken"
					skipped += 1
				else
					inserted += 1
				end
			end
			{ inserted: inserted, skipped: skipped }
		end
	end

	def self.most_recent(count)
		order(date: :desc, id: :desc).first(count)
	end

	def tag_with(tag_name)
	end
end
