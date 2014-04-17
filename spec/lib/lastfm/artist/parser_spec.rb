require 'spec_helper'

describe Lastfm::Artist::Parser do
  subject { described_class }

  describe '.parse' do
    it 'parses artist info' do
      data = fixture('lastfm/artist.json').read

      artist = OpenStruct.new(subject.parse(data))

      expect(artist.name).to eql('Bombay Bicycle Club')
      expect(artist.musicbrainz_uuid).to eql('0ae49abe-d6af-44fa-8ab0-b9ace5690e6f')
      expect(artist.lastfm_url).to eql('http://www.last.fm/music/Bombay+Bicycle+Club')
      expect(artist.lastfm_image_small).to eql('http://userserve-ak.last.fm/serve/34/96722267.jpg')
      expect(artist.lastfm_image_medium).to eql('http://userserve-ak.last.fm/serve/64/96722267.jpg')
      expect(artist.lastfm_image_large).to eql('http://userserve-ak.last.fm/serve/126/96722267.jpg')
      expect(artist.lastfm_image_extralarge).to eql('http://userserve-ak.last.fm/serve/252/96722267.jpg')
      expect(artist.lastfm_image_mega).to eql('http://userserve-ak.last.fm/serve/500/96722267/Bombay+Bicycle+Club+BombayBicycleClubimage.jpg')
      expect(artist.tags).to eql(['indie', 'british', 'indie rock', 'alternative', 'indie pop'])
    end
  end

  describe '.parse_tracks' do
    it 'parses tracks' do
      data = fixture('lastfm/tracks.json').read

      tracks = subject.parse_tracks(data)

      expect(tracks.size).to eql(50)
      expect(tracks.first).to eql('Shuffle')
    end
  end
end
