require 'spec_helper'

describe Event do
  it 'requires poster' do
    DownloaderService.stub(:fetch) { nil }

    event = build :event

    expect(event).not_to be_valid
    expect(event).to have(1).error_on(:poster)

    DownloaderService.stub(:fetch) { fixture('poster.jpg') }

    event = build :event

    expect(event).to be_valid
    expect(event.poster.file).not_to be_nil
  end

  describe 'callbacks' do
    describe '#set_tags' do
      it 'sets first tags from artists' do
        event   = create :event
        artists = [
          create(:artist, tags: ['rock', 'pop']),
          create(:artist, tags: ['rock', 'indie']),
          create(:artist, tags: ['grunge'])
        ]

        artists.each do |artist|
          create :performance, event: event, artist: artist
        end

        event.reload

        expect(event.tags).to eql(['rock', 'grunge'])
      end
    end
  end

  describe '.in' do
    before :each do
      create :event, venue_country: 'Slovakia'

      3.times { create :event, venue_country: 'Poland' }

      create :event, venue_country: 'Bogus'
    end

    it 'returns events in specific countries' do
      events = Event.in(['Slovakia', 'Poland'])

      expect(events.size).to eql(4)
      expect(events.pluck(:venue_country).uniq.sort).to eql(['Poland', 'Slovakia'])
    end
  end

  describe '.with' do
    let(:events) { 3.times.map { create :event }}
    let(:artists) { 3.times.map { create :artist }}

    before :each do
      artists[0].update_attributes(tags: ['rock'])
      artists[1].update_attributes(tags: ['rock', 'pop'])
      artists[2].update_attributes(tags: ['dubstep'])

      artists.each_with_index do |artist, index|
        create :performance, artist: artist, event: events[index]
      end

      events.each(&:reload)
    end

    it 'returns events having artist tag' do
      other = Event.with(['rock'])

      expect(other.size).to eql(2)
      expect(other.to_a.sort).to eql([events[0], events[1]].sort)
    end

    it 'returns events having multiple tags' do
      other = Event.with(['pop', 'dubstep'])

      expect(other.size).to eql(2)
      expect(other.to_a.sort).to eql([events[1], events[2]].sort)
    end
  end

  describe '.search_by' do
    it 'searches event by title' do
      events = [
        create(:event, title: 'Pohoda 2014'),
        create(:event, title: 'Bažant Pohoda 2015'),
        create(:event, title: 'Coachella')
      ]

      results = Event.search_by(title: 'bazant')

      expect(results.size).to eql(1)
      expect(results.first).to eql(events[1])
    end
  end

  describe '.create_from_lastfm' do
    let(:data) {
      {
        lastfm_uuid:             "3705233",
        title:                   "GRAPE FESTIVAL 2014",
        headliner:               "Editors",
        venue_name:              "Letisko",
        venue_latitude:          "48.625",
        venue_longitude:         "17.828611",
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
