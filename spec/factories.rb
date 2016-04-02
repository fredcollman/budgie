FactoryGirl.define do
	factory :transaction do
		sequence(:date) { |n| n.days.ago }
		description "A Transaction"
		sequence(:amount) { |n| 10*n }
	end
end
