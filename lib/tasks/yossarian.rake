namespace :yossarian do
  desc 'Get festivals'
  task festivals: :environment do
    Lastfm::Events.factory = Yossarian::EventFactory

    Lastfm::Events.get(location: :slovakia, festivalsonly: 1, limit: 100)
  end

  desc 'Get artists'
  task artists: :environment do
    Lastfm::Artist.factory = Yossarian::ArtistFactory

    Artist.order(:created_at).find_each do |artist|
      Lastfm::Artist.get(artist: artist.name)
    end
  end

  desc 'Get youtube videos'
  task youtube: :environment do
    Recording.order(:created_at).find_each do |recording|
      Yossarian::RecordingFactory.create_from_youtube(artist: recording.artist.name, track: recording.track.name)
    end
  end
end
