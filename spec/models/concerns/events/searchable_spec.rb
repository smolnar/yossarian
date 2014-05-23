require 'spec_helper'

shared_examples_for Events::Searchable do
  describe '.search' do
    it 'searches event by title' do
      events = [
        create(:event, title: 'Pohoda 2014'),
        create(:event, title: 'Bažant Pohoda 2015'),
        create(:event, title: 'Coachella')
      ]

      results = Event.search('bazant')

      expect(results.size).to eql(1)
      expect(results.first).to eql(events[1])
    end

    it 'searches event by artists names' do
      events = [
        create(:event, title: 'Grape 2014'),
        create(:event, title: 'Bažant Pohoda 2015'),
        create(:event, title: 'Coachella')
      ]

      artists = [
        create(:artist, name: 'Local Natives'),
        create(:artist, name: 'Bombay Bicycle Club'),
        create(:artist, name: 'Editors')
      ]

      artists[0..1].each do |artist|
        create :performance, artist: artist, event: events[0]
        create :performance, artist: artist, event: events[1]
      end

      create :performance, artist: artists[2], event: events[1]

      results = Event.search('bom')

      expect(results.size).to eql(2)
      expect(results.to_a.sort).to eql(events[0..1].sort)
    end
  end
end
