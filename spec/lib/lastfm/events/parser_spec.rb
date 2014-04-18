require 'spec_helper'

describe Lastfm::Events::Parser do
  subject { described_class }

  describe '.parse' do
    it 'parses event details' do
      data = JSON.parse(fixture('lastfm/events.json').read, symbolize_names: true)

      metadata, events = subject.parse(data)

      expect(metadata[:page]).to eql(1)
      expect(metadata[:per_page]).to eql(100)
      expect(metadata[:total_pages]).to eql(1)
      expect(metadata[:total]).to eql(27)

      expect(events.size).to eql(27)

      event = events.find { |e| e[:title] == 'GRAPE FESTIVAL 2014' }

      expect(event).to eql(
        lastfm_uuid:            "3705233",
        title:                  "GRAPE FESTIVAL 2014",
        headliner:              "Editors",
        venue_name:             "Letisko",
        venue_latitude:         "48.625",
        venue_longitude:        "17.828611",
        venue_city:              "Piešťany",
        venue_country:           "Slovakia",
        venue_street:            "",
        starts_at:               Time.parse('2014-08-15 13:38:01 +0200'),
        ends_at:                 Time.parse('2014-08-16 13:38:01 +0200'),
        website:                 "http://www.grapefestival.sk/",
        lastfm_url:              "http://www.last.fm/festival/3705233+GRAPE+FESTIVAL+2014",
        lastfm_image_small:      "http://userserve-ak.last.fm/serve/34/36233633.jpg",
        lastfm_image_medium:     "http://userserve-ak.last.fm/serve/64/36233633.jpg",
        lastfm_image_large:      "http://userserve-ak.last.fm/serve/126/36233633.jpg",
        lastfm_image_extralarge: "http://userserve-ak.last.fm/serve/252/36233633.jpg",
        artists: [
          "Editors",
          "Klaxons",
          "La Roux",
          "Bombay Bicycle Club",
          "Flux Pavilion",
          "Palma Violets",
          "Wilkinson",
          "Diego",
          "Skyline",
          "Rangleklods",
          "The Prostitutes",
          "Vec",
          "Lavagance",
          "Le Payaco",
          "Fiordmoss",
          "Korben Dallas",
          "Modré hory",
          "Strapo",
          "The Feud",
          "No Distance Paradise",
          "Boyband",
          "Walter Schnitzelsson",
          "Fallgrapp",
          "Saténové Ruky",
          "Papyllon",
          "MALALATA",
          "Tichonov",
          "Martina Javor"
        ]
      )
    end

    context 'with error' do
      it 'ommits parsing events' do
        data = { error: 6, message: 'The location you supplied could not be found' }.to_json

        expect(subject.parse(data)).to be_nil
      end
    end
  end
end
