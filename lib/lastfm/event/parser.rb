module Lastfm::Event
  module Parser
    def self.parse(data)
      result = OpenStruct.new

      result.lastfm_uuid     = data[:id]
      result.title           = data[:title]
      result.artists         = data[:artists][:artist]
      result.headliner       = data[:artists][:headliner]
      result.venue_name      = data[:venue][:name]
      result.venue_latitude  = data[:venue][:location][:'geo:point'][:'geo:lat']
      result.venue_longitude = data[:venue][:location][:'geo:point'][:'geo:long']
      result.venue_city      = data[:venue][:location][:city]
      result.venue_country   = data[:venue][:location][:country]
      result.venue_street    = data[:venue][:location][:street]
      result.starts_at       = Time.parse(data[:startDate])
      result.ends_at         = Time.parse(data[:endDate])
      result.description     = data[:description]
      result.website         = data[:website]
      result.lastfm_url      = data[:url]

      data[:image].each do |image|
        result.send("lastfm_image_#{image[:size]}=", image[:'#text'].strip)
      end

      result
    end
  end
end
