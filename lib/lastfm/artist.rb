module Lastfm
  module Artist
    extend self

    attr_accessor :downloader, :factory

    def downloader
      @downloader ||= Scout::Downloader
    end

    def factory
      @factory ||= Yossarian::ArtistFactory
    end

    def get(params = {})
      query = params.map { |key, value| "#{key}=#{value}" }.join('&')
      url   = "#{Lastfm.config.artist.url}&format=json&#{query}"

      response = downloader.download(url)
      data     = JSON.parse(response, symbolize_names: true)
      artist   = data[:artist]

      url      = "#{Lastfm.config.artist.tracks.url}&format=json&#{query}"
      response = downloader.download(url)
      data     = JSON.parse(response, symbolize_names: true)

      tracks   = data[:toptracks][:track]

      factory.create_from_lastfm(artist.merge(tracks: tracks))
    end
  end
end
