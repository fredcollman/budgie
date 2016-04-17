require 'date'
require_relative '../../app/helpers/date_helper'

describe DateHelper do
	let (:formatter) { Class.new { include DateHelper }.new }

	it 'formats short dates' do
		expect(formatter.format_date(Date.new(1999, 12, 31), :short)).to eq "31/12"
	end

	it 'formats long dates' do
		expect(formatter.format_date(Date.new(1999, 12, 31), :long)).to eq "31 Dec 1999"
	end
end
