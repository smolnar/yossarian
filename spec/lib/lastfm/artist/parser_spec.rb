require 'spec_helper'

describe Lastfm::Artist::Parser do
  subject { described_class }

  describe '.parse' do
    it 'parses artist info' do
      data = fixture('lastfm/artist.json').read

      artist = subject.parse(data)

      expect(artist).to eql(
        name:                    "Bombay Bicycle Club",
        lastfm_url:              "http://www.last.fm/music/Bombay+Bicycle+Club",
        musicbrainz_uuid:        "0ae49abe-d6af-44fa-8ab0-b9ace5690e6f",
        lastfm_image_small:      "http://userserve-ak.last.fm/serve/34/96722267.jpg",
        lastfm_image_medium:     "http://userserve-ak.last.fm/serve/64/96722267.jpg",
        lastfm_image_large:      "http://userserve-ak.last.fm/serve/126/96722267.jpg",
        lastfm_image_extralarge: "http://userserve-ak.last.fm/serve/252/96722267.jpg",
        lastfm_image_mega:       "http://userserve-ak.last.fm/serve/500/96722267/Bombay+Bicycle+Club+BombayBicycleClubimage.jpg",
        tags:                    ["indie", "british", "indie rock", "alternative", "indie pop"],
      )
    end

    context 'with error' do
      it 'ommit parsing information' do
        data = { error: 6, message: 'The artist you supplied could not be found' }.to_json

        expect(subject.parse(data)).to be_nil
      end
    end
  end

  describe '.parse_tracks' do
    it 'parses tracks' do
      data = fixture('lastfm/tracks.json').read

      tracks = subject.parse_tracks(data)

      expect(tracks.size).to eql(50)
      expect(tracks.first).to eql('Shuffle')
    end

    context 'with error' do
      it 'returns empty array' do
        data = { error: 6, message: 'the artist you supplied could not be found' }.to_json

        expect(subject.parse_tracks(data)).to eql([])
      end
    end

    context 'with parse error' do
      it 'returns empty array' do
        data = '""'

        expect(subject.parse_tracks(data)).to eql([])
      end
    end
  end
end
