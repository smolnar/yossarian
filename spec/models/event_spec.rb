require 'spec_helper'

describe Event do
  describe '.create_from_lastfm' do
    let(:data) {
      {
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
      }
    }

    it 'creates event from lastfm attributes' do
      event = Event.create_from_lastfm(data)

      data.except(:headliner, :artists).each do |key, value|
        expect(event.read_attribute(key)).to eql(value)
      end

      expect(data[:artists].sort).to eql(event.artists.pluck(:name).sort)
      expect(data[:headliner]).to eql(event.headliners.first.name)
    end

    it 'disallows timestamps attributes' do
      Timecop.freeze(Time.now) do
        params = data.merge(created_at: 2.days.ago, updated_at: 1.day.ago)

        event = Event.create_from_lastfm(params)

        expect(event.created_at).to eql(Time.now)
        expect(event.updated_at).to eql(Time.now)
      end
    end
  end
end
