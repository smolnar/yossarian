FactoryGirl.define do
  factory :event do
    sequence(:title)   { |n| "Event ##{n}" }
    sequence(:website) { |n| "http://event_#{n}.com" }

    sequence(:lastfm_uuid) { |n| "#{n}" }
    sequence(:lastfm_url)  { "http://www.last.fm/festival/3705233+GRAPE+FESTIVAL+2014" }
    sequence(:lastfm_image_extralarge) { |n| "http://userserve-ak.last.fm/serve/252/#{n}.jpg" }

    sequence(:venue_name)    { |n| "Venue ##{n}"}
    sequence(:venue_city)    { |n| "City ##{n}" }
    sequence(:venue_country) { |n| "Country ##{n}" }

    venue_latitude  '48.625'
    venue_longitude '17.828611'

    starts_at { Time.now + 1.day }
    ends_at   { Time.now + 2.days }

    trait :with_artists do
      after :create do |event|
        3.times do
          create :performance, event: event
        end
      end
    end
  end
end
