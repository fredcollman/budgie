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
		begin
			m = line.gsub(/[[:space:]]/, ' ').match(/^\s*#{@@fields[field][0]}: #{@@fields[field][1]}/)
		rescue Exception => e
			raise TransactionParseError, e
		end
		m or raise TransactionParseError, line
	end
end

class TransactionParseError < Exception
end
