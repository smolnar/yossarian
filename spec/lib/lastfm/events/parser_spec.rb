require 'spec_helper'

describe Lastfm::Events::Parser do
  subject { described_class }

  describe '.parse' do
    it 'parses event details' do
      data = JSON.parse(fixture('lastfm/events.json').read, symbolize_names: true)

      metadata, events = subject.parse(data)

      metadata = OpenStruct.new(metadata)

      expect(metadata.page).to eql(1)
      expect(metadata.per_page).to eql(100)
      expect(metadata.total_pages).to eql(1)
      expect(metadata.total).to eql(27)

      expect(events.size).to eql(27)

      event = OpenStruct.new(events.find { |e| e[:title] == 'GRAPE FESTIVAL 2014' })

      expect(event.title).to eql('GRAPE FESTIVAL 2014')
      expect(event.artists).to eql([
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
      ])
      expect(event.headliner).to eql('Editors')
      expect(event.venue_name).to eql('Letisko')
      expect(event.venue_latitude).to eql('48.625')
      expect(event.venue_longitude).to eql('17.828611')
      expect(event.venue_city).to eql('Piešťany')
      expect(event.venue_country).to eql('Slovakia')
      expect(event.starts_at).to eql(Time.new(2014, 8, 15, 13, 38, 1))
      expect(event.ends_at).to eql(Time.new(2014, 8, 16, 13, 38, 1))
      expect(event.lastfm_image_small).to eql('http://userserve-ak.last.fm/serve/34/36233633.jpg')
      expect(event.lastfm_image_medium).to eql('http://userserve-ak.last.fm/serve/64/36233633.jpg')
      expect(event.lastfm_image_large).to eql('http://userserve-ak.last.fm/serve/126/36233633.jpg')
      expect(event.lastfm_image_extralarge).to eql('http://userserve-ak.last.fm/serve/252/36233633.jpg')
      expect(event.lastfm_url).to eql('http://www.last.fm/festival/3705233+GRAPE+FESTIVAL+2014')
      expect(event.website).to eql('http://www.grapefestival.sk/')
    end
  end
end
