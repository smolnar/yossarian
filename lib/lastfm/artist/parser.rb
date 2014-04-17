# TODO (smolnar) parse summary

module Lastfm::Artist
  module Parser
    def self.parse(data)
      data   = JSON.parse(data, symbolize_names: true)
      result = Hash.new

      result[:name]             = data[:name]
      result[:lastfm_url]       = data[:url]
      result[:tags]             = data[:tags][:tag].map { |tag| tag[:name] }
      result[:musicbrainz_uuid] = data[:mbid]

      data[:image].each do |image|
        result[:"lastfm_image_#{image[:size]}"] = image[:'#text']
      end

      result
    end

    def self.parse_tracks(data)
      data = JSON.parse(data, symbolize_names: true)

      data[:toptracks][:track].map { |track| track[:name] }
    end
  end
end
