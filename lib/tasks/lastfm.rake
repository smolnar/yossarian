namespace :lastfm do
  desc 'Get events'
  task events: :environment do
    Lastfm::Events.get(location: :europe)
  end
end
