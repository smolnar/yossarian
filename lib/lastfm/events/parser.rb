# TODO (smolnar) parse description

module Lastfm::Events
  module Parser
    def self.parse(data)
      data     = JSON.parse(data, symbolize_names: true) unless data.is_a?(Hash)
      metadata = Lastfm::Metadata::Parser.parse(data[:events])

      events = data[:events][:event].map do |event|
        result = Hash.new

        result[:lastfm_uuid]     = event[:id]
        result[:title]           = event[:title]
        result[:artists]         = Array.wrap(event[:artists][:artist])
        result[:headliner]       = event[:artists][:headliner]
        result[:venue_name]      = event[:venue][:name]
        result[:venue_latitude]  = event[:venue][:location][:'geo:point'][:'geo:lat']
        result[:venue_longitude] = event[:venue][:location][:'geo:point'][:'geo:long']
        result[:venue_city]      = event[:venue][:location][:city]
        result[:venue_country]   = event[:venue][:location][:country]
        result[:venue_street]    = event[:venue][:location][:street]
        result[:starts_at]       = Time.parse(event[:startDate]) if event[:startDate]
        result[:ends_at]         = Time.parse(event[:endDate]) if event[:endDate]
        result[:description]     = event[:description]
        result[:website]         = event[:website]
        result[:lastfm_url]      = event[:url]

        event[:image].each do |image|
          result[:"lastfm_image_#{image[:size]}"] = image[:'#text']
        end

        result
      end

      return metadata, events
    end
  end
end
