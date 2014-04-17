namespace :lastfm do
  desc 'Get events'
  task events: :environment do
    Lastfm::Events.get(location: :europe, festivalsonly: 1, limit: 100)
  end

  desc 'Get artists'
  task artists: :environment do
    Artist.find_each do |artist|
      Lastfm::Artist.get(artist: artist.name)
    end
  end
end
