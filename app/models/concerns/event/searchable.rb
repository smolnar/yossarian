class Event
  module Searchable
    extend ActiveSupport::Concern

    module ClassMethods
      def search(term, options = {})
        query = <<-SQL
          lower(musicbrainz_unaccent(title)) LIKE lower(musicbrainz_unaccent(:query))
          OR
          lower(musicbrainz_unaccent(artists.name)) LIKE lower(musicbrainz_unaccent(:query))
        SQL

        includes(:artists).references(:artists).where(query, query: "%#{term}%").uniq
      end
    end
  end
end
