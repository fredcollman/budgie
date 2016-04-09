class Transaction < ActiveRecord::Base
	validates :date, presence: true
	validates :description, presence: true
	validates :amount, presence: true
	validates :description, uniqueness: { scope: [:date, :balance] }

	def self.insert_many!(transactions)
		Transaction.transaction do 
			inserted = 0
			skipped = 0
			transactions.each do |t| 
				begin
					Transaction.create!({
						date: t.date,
						description: t.description,
						amount: t.amount,
						balance: t.balance
					})
				rescue ActiveRecord::RecordInvalid => e
					raise e unless e.message == "Validation failed: Description has already been taken"
					skipped += 1
				else
					inserted += 1
				end
			end
			{ inserted: inserted, skipped: skipped }
		end
	end

	def self.most_recent(count)
		order(date: :desc).first(count)
	end
end
