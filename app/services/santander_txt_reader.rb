require 'date'

class SantanderTxtReader
	def self.from_file(filename)
		self.from_lines(File.foreach(filename))
	end

	def self.from_lines(lines)
		SantanderTxtReader.new
	end

	def next
		SantanderTransaction.new(
			SantanderTxtParser.parse_description
		)
	end
end

class SantanderTxtParser
	def self.parse_date
	end

	def self.parse_description
	end

	def self.parse_amount
	end
end

SantanderTransaction = Struct.new(:description)
