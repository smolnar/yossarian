require 'spec_helper'

shared_examples_for Artists::Buildable do
  describe '.create_from_lastfm' do
    let(:data) {
      {
        name:                    "Bombay Bicycle Club",
        lastfm_url:              "http://www.last.fm/music/Bombay+Bicycle+Club",
        musicbrainz_uuid:        "0ae49abe-d6af-44fa-8ab0-b9ace5690e6f",
        lastfm_image_small:      "http://userserve-ak.last.fm/serve/34/96722267.jpg",
        lastfm_image_medium:     "http://userserve-ak.last.fm/serve/64/96722267.jpg",
        lastfm_image_large:      "http://userserve-ak.last.fm/serve/126/96722267.jpg",
        lastfm_image_extralarge: "http://userserve-ak.last.fm/serve/252/96722267.jpg",
        lastfm_image_mega:       "http://userserve-ak.last.fm/serve/500/96722267/Bombay+Bicycle+Club+BombayBicycleClubimage.jpg",
        tags:                    ["indie", "british", "indie rock", "alternative", "indie pop"],
        tracks:                  ['Shuffle']
      }
    }

    it 'creates artist with lastfm attributes' do
      artist = Artist.create_from_lastfm(data)

      data.except(:tracks).each do |key, value|
        expect(artist.read_attribute(key)).to eql(value)
      end

      expect(artist.tracks.pluck(:name)).to eql(['Shuffle'])
    end
  end
end
