namespace :yossarian do
  desc 'Get festivals'
  task festivals: :environment do
    Lastfm::Events.get(location: :europe, festivalsonly: 1, limit: 100)
  end

  desc 'Get artists'
  task artists: :enviroment do
    Artist.find_each do |artist|
      Lastfm::Artist.get(artist: artist.name)
    end
  end

  desc 'Get youtube videos'
  task youtube: :environment do
    Recording.find_each do |recording|
      Yossarian::RecordingFactory.create_from_youtube(artist: recording.artist.name, track: recording.track.name)
    end
  end
end
