require 'date'

class SantanderTxtReader
	include Enumerable
	
	def initialize(lines)
		@lines = lines
	end

	def self.from_file(file)
		self.from_lines(file.each_line)
	end

	def self.from_lines(lines)
		SantanderTxtReader.new(lines.each)
	end

	def next
		date = nil
		while date.nil? do
			date = SantanderTxtParser.parse_date(@lines.next)
		end
		begin
			description = SantanderTxtParser.parse_description(@lines.next)
			amount = SantanderTxtParser.parse_amount(@lines.next)
			balance = SantanderTxtParser.parse_balance(@lines.next)
		rescue StopIteration
			raise TransactionParseError, 'incomplete transaction'
		end
		SantanderTransaction.new(date, description, amount, balance)
	end

	def each
		loop do
			yield self.next
		end
	end
end

class SantanderTransaction < Struct.new(:date, :description, :amount, :balance)
	def initialize(date, description, amount, balance)
		if [date, description, amount, balance].all?
			super(date, description, amount, balance)
		else
			raise TransactionParseError, "SantanderTransaction.new(#{date}, #{description}, #{amount}, #{balance})"
		end
	end
end
