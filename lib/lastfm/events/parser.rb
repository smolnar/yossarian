# TODO (smolnar) parse description

module Lastfm::Events
  module Parser
    def self.parse(data)
      data = JSON.parse(data, symbolize_names: true) unless data.is_a?(Hash)

      return if data[:error]

      metadata = Lastfm::Metadata::Parser.parse(data[:events])

      events = data[:events][:event].map do |event|
        result = Hash.new

        result[:lastfm_uuid]     = event[:id].presence
        result[:title]           = event[:title].presence
        result[:artists]         = Array.wrap(event[:artists][:artist]).presence
        result[:headliner]       = event[:artists][:headliner].presence
        result[:venue_name]      = event[:venue][:name].presence
        result[:venue_latitude]  = event[:venue][:location][:'geo:point'][:'geo:lat'].presence
        result[:venue_longitude] = event[:venue][:location][:'geo:point'][:'geo:long'].presence
        result[:venue_city]      = event[:venue][:location][:city].presence
        result[:venue_country]   = event[:venue][:location][:country].presence
        result[:venue_street]    = event[:venue][:location][:street].presence
        result[:starts_at]       = Time.parse(event[:startDate]) if event[:startDate]
        result[:ends_at]         = Time.parse(event[:endDate]) if event[:endDate]
        result[:website]         = event[:website].presence
        result[:lastfm_url]      = event[:url].presence

        event[:image].each do |image|
          result[:"lastfm_image_#{image[:size]}"] = image[:'#text']
        end

        result
      end

      return metadata, events
    end
  end
end
