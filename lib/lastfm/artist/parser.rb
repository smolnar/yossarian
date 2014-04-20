# TODO (smolnar) parse summary

module Lastfm::Artist
  module Parser
    def self.parse(data)
      data   = JSON.parse(data, symbolize_names: true)
      result = Hash.new

      return if data[:error]

      data = data[:artist]

      result[:name]             = data[:name].presence
      result[:lastfm_url]       = data[:url].presence
      result[:tags]             = Array.wrap(data[:tags][:tag]).map { |tag| tag[:name].presence } if data[:tags].is_a?(Hash)
      result[:musicbrainz_uuid] = data[:mbid].presence

      data[:image].each do |image|
        result[:"lastfm_image_#{image[:size]}"] = image[:'#text'].presence
      end

      result
    end

    def self.parse_tracks(data)
      begin
        data = JSON.parse(data, symbolize_names: true)
      rescue JSON::ParserError
        return []
      end

      return [] if data[:error]

      Array.wrap(data[:toptracks][:track]).map { |track| track[:name].presence }
    end
  end
end
