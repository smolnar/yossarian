namespace :yossarian do
  desc 'Get festivals'
  task festivals: :environment do
    Lastfm::Events.factory = Yossarian::EventFactory

    Lastfm::Events.get(location: :europe, festivalsonly: 1, limit: 100)
  end

  desc 'Get artists'
  task artists: :environment do
    Lastfm::Artist.factory = Yossarian::ArtistFactory

    Artist.where(lastfm_url: nil).find_each do |artist|
      Lastfm::Artist.get(artist: artist.name) rescue nil
    end
  end

  desc 'Get youtube videos'
  task youtube: :environment do
    Recording.find_each do |recording|
      Yossarian::RecordingFactory.update_from_youtube(recording.id)
    end
  end

  desc 'Clean data for production'
  task clean: :environment do
    Recording.where(youtube_url: nil).each(&:destroy!)
    Artist.where(image: nil).each(&:destroy!)
  end
end
