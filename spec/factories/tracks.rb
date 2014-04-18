# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :track do
    sequence(:name) { |n| "Track ##{n}" }
  end
end
