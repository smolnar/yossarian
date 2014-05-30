require 'spec_helper'
require 'models/concerns/events/buildable_spec'
require 'models/concerns/events/searchable_spec'

describe Event do
  it_behaves_like Events::Buildable
  it_behaves_like Events::Searchable

  it 'requires title' do
    event = build :event, title: nil

    expect(event).not_to be_valid

    event = build :event, title: 'Coachella'

    expect(event).to be_valid
  end

  it 'requires latitude and longitude' do
    event = build :event, venue_longitude: nil, venue_latitude: nil

    expect(event).not_to be_valid

    event = build :event, venue_longitude: 12, venue_latitude: 13

    expect(event).to be_valid
  end

  it 'requires start date' do
    event = build :event, starts_at: nil

    expect(event).not_to be_valid

    event = build :event, starts_at: Time.now

    expect(event).to be_valid
  end

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

        expect(event.tags).to eql(['rock', 'grunge'])
        expect(event.reload.tags).to eql(['rock', 'grunge'])
      end
    end

    describe '#set_notable_performances_count' do
      it 'sets performances count having artist image and recording youtube url' do
        event   = create :event
        artists = 3.times.map { create :artist, image: fixture('poster.jpg') }

        artists << create(:artist)

        create :recording, artist: artists[0]

        artists[1..3].each do |artist|
          create :recording, artist: artist, youtube_url: nil
        end

        artists.each do |artist|
          create :performance, artist: artist, event: event
        end

        expect(event.notable_performances_count).to eql(1)
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

    before :each do
      events[0].update_attributes(tags: ['rock'])
      events[1].update_attributes(tags: ['rock', 'pop'])
      events[2].update_attributes(tags: ['dubstep'])
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
end
