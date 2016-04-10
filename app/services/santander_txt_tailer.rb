require_relative 'santander_txt_parser'

class SantanderTxtTailer
	include Enumerable

	def initialize(lines)
		@lines = lines.each
	end

	def next
		balance = nil
		while balance.nil?
			balance = SantanderTxtParser.parse_balance(@lines.next)
		end
		begin
			amount = SantanderTxtParser.parse_amount(@lines.next)
			description = SantanderTxtParser.parse_description(@lines.next)
			date = SantanderTxtParser.parse_date(@lines.next)
		rescue StopIteration
			raise TransactionParseError, 'incomplete transaction'
		end
		SantanderTxtTailer::SantanderTransaction.new(date, description, amount, balance)
	end

	def each(&block)
		loop do
			yield self.next
		end
	end
end

class SantanderTxtTailer::SantanderTransaction < Struct.new(:date, :description, :amount, :balance)
	def initialize(date, description, amount, balance)
		if [date, description, amount, balance].all?
			super(date, description, amount, balance)
		else
			raise TransactionParseError, "SantanderTransaction.new(#{date}, #{description}, #{amount}, #{balance})"
		end
	end
end
