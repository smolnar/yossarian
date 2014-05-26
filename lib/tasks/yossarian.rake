namespace :yossarian do
  desc 'Get festivals'
  task festivals: :environment do
    Lastfm::Events.factory = Yossarian::EventFactory

    Lastfm::Events.get(location: :europe, festivalsonly: 1, limit: 100)
  end

  desc 'Get artists'
  task artists: :environment do
    Lastfm::Artist.factory = Yossarian::ArtistFactory

    Artist.where(lastfm_url: nil).order(:created_at).find_each do |artist|
      Lastfm::Artist.get(artist: artist.name) rescue nil
    end
  end

  desc 'Get youtube videos'
  task youtube: :environment do
    Recording.where(youtube_url: nil).order(:created_at).find_each do |recording|
      Yossarian::RecordingFactory.create_from_youtube(artist: recording.artist.name, track: recording.track.name)
    end
  end
end
