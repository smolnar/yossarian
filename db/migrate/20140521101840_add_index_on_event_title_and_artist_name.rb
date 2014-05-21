class AddIndexOnEventTitleAndArtistName < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX index_events_unaccented_lowercased_title
      ON events (lower(musicbrainz_unaccent(title)));
    SQL

    execute <<-SQL
      CREATE INDEX index_artists_unaccented_lowercased_name
      ON artists (lower(musicbrainz_unaccent(name)));
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX index_events_unaccented_lowercased_title;
    SQL

    execute <<-SQL
      DROP INDEX index_artists_unaccented_lowercased_name;
    SQL
  end
end
