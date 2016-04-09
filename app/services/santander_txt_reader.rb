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

class SantanderTxtParser
	@@fields = {
		date: ['Date', '(\d{2})/(\d{2})/(\d{4})'],
		description: ['Description', '(.*)'],
		amount: ['Amount', '(-?\d+\.\d+)'],
		balance: ['Balance', '(-?\d+\.\d+)']
	}

	def self.parse_description(text)
		parse(:description, text) { |m| m[1].strip }
	end

	def self.parse_amount(text)
		parse(:amount, text) { |m| m[1].to_f }
	end

	def self.parse_date(text)
		parse(:date, text) do |m|
			begin
				Date.new(m[3].to_i, m[2].to_i, m[1].to_i)
			rescue ArgumentError
				raise TransactionParseError, text
			end
		end
	end

	def self.parse_balance(text)
		parse(:balance, text) { |m| m[1].to_f }
	end

	def self.parse(field, text)
		m = nil
		text.each_line do |line|
			if line.strip.start_with?(@@fields[field][0])
				m = parse_line(field, line)
			end
		end
		yield m unless m.nil?
	end

	def self.parse_line(field, line)
		m = line.gsub(/[[:space:]]/, ' ').match(/^\s*#{@@fields[field][0]}: #{@@fields[field][1]}/)
		m or raise TransactionParseError, line
	end
end

class TransactionParseError < Exception
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
