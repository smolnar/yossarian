namespace :lastfm do
  desc 'Get events'
  task events: :environment do
    Lastfm::Events.get(location: :europe, festivalsonly: 1, limit: 100)
  end
end
