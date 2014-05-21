class AddUnaccentExtension < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE EXTENSION IF NOT EXISTS musicbrainz_unaccent;
    SQL
  end

  def down
    execute <<-SQL
      DROP EXTENSION IF EXISTS musicbrainz_unaccent;
    SQL
  end
end
