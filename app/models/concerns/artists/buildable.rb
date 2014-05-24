module Artists
  module Buildable
    extend ActiveSupport::Concern

    module ClassMethods
      def create_from_lastfm(data)
        artist     = find_or_initialize_by(name: data[:name])
        attributes = (data.keys & columns.map { |c| c.name.to_sym }) - [:created_at, :updated_at]

        artist.attributes = data.slice(*attributes)

        artist.save!

        data[:tracks].each do |name|
          next unless name.present?

          track = Track.find_or_create_by!(name: name)

          Recording.find_or_create_by!(artist: artist, track: track)
        end

        artist
      end
    end
  end
end
