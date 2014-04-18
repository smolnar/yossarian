FactoryGirl.define do
  factory :performance do
    association(:artist)
    association(:event)

    headliner false
  end
end
