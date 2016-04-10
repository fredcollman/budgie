require 'elif'

class SantanderUploader
	def self.upload(file)
		SantanderTxtTailer.new(file_to_lines(file))
	end

	def self.file_to_lines(file)
		Enumerator.new do |y|
			Elif.open(file).each_line do |line|
				y << line.force_encoding('windows-1252')
			end
		end
	end
end
