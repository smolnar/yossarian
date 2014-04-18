module Lastfm
  module Artist
    extend self

    attr_accessor :downloader, :factory, :parser

    def downloader
      @downloader ||= Scout::Downloader
    end

    def parser
      @parser ||= Lastfm::Artist::Parser
    end

    def get(params = {})
      raise ArgumentError.new("You need to provide 'factory'") unless factory

      query = params.map { |key, value| "#{key}=#{value}" }.join('&')
      url   = "#{Lastfm.config.artist.url}&format=json&#{query}"

      response = downloader.download(url)
      artist   = parser.parse(response)

      return unless artist

      url      = "#{Lastfm.config.artist.tracks.url}&format=json&#{query}"
      response = downloader.download(url)

      artist.merge!(tracks: parser.parse_tracks(response))

      factory.create_from_lastfm(artist)
    end
  end
end
