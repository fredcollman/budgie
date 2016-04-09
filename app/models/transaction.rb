class Transaction < ActiveRecord::Base
	validates :date, presence: true
	validates :description, presence: true
	validates :amount, presence: true

	def self.insert_many!(transactions)
		Transaction.transaction do 
			transactions.each do |t| 
				Transaction.create!({
					date: t.date,
					description: t.description,
					amount: t.amount,
					balance: t.balance
				})
			end
		end
	end

	def self.most_recent(count)
		order(date: :desc).first(count)
	end
end
