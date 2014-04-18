# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :recording do
    association(:artist)
    association(:track)

    sequence(:youtube_url) { |n| "http://youtube.com/#{n}" }
  end
end
