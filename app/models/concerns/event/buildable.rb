class Event
  module Buildable
    extend ActiveSupport::Concern

    module ClassMethods
      def create_from_lastfm(data)
        data  = data.symbolize_keys
        event = find_by(lastfm_uuid: data[:lastfm_uuid]) || find_or_initialize_by(title: data[:title])

        attributes = (data.keys & columns.map { |c| c.name.to_sym }) - [:created_at, :updated_at]

        event.attributes = data.slice(*attributes)

        event.save!

        data[:artists].each do |name|
          artist = Artist.find_or_create_by!(name: name)

          Performance.find_or_create_by!(artist: artist, event: event, headliner: data[:headliner] == name)
        end

        event
      end
    end
  end
end
