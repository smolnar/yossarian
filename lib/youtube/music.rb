module Youtube
  class Music
    def self.of(artist: artist, track: track)
      query    = "\"#{artist} - #{track}\""
      client   = YouTubeIt::Client.new
      response = client.videos_by(query: query, categories: [:music], order_by: :relevance)

      videos = response.videos.find_all { |video| video.state[:name].to_sym == :published }

      videos.map { |video| Youtube::Video.new(video) }
    end
  end
end
