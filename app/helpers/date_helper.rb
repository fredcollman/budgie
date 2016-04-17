module DateHelper
	@@date_formats = {
		short: "%d/%m",
		long: "%d %b %Y"
	}

	def format_date(date, format)
		date.strftime(@@date_formats[format])
	end
end