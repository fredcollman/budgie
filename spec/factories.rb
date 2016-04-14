FactoryGirl.define do
	factory :entry do
		sequence(:date) { |n| n.days.ago }
		description "An entry made by FactoryGirl"
		sequence(:amount) { |n| 10*n }
	end

	factory :tag do
		sequence(:name) { |n| "tag#{n}" }
		description "A tag made by FactoryGirl"
	end
end
