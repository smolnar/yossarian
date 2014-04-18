FactoryGirl.define do
  factory :performance do
    association(:artist)
    association(:event)
  end
end
