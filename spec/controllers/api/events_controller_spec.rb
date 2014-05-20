require 'spec_helper'

describe API::EventsController do
  describe 'GET index' do
    let(:events) { 5.times.map { |n| create :event, venue_country: "Country ##{n}" } }
    let(:artists_with_image) { 5.times.map { create :artist, image: fixture('poster.jpg') }}
    let(:artists_without_image) { 5.times.map { create :artist, image: nil }}

    before :each do
      artists_with_image[0..1].each do |artist|
        create :recording,   artist: artist
        create :performance, artist: artist, event: events.first
      end

      artists_with_image[2..3].each_with_index do |artist, index|
        create :recording,   artist: artist
        create :performance, artist: artist, event: events[index + 1]
      end

      create :recording,   artist: artists_with_image.last, youtube_url: nil
      create :performance, artist: artists_with_image.last, event: events.first

      artists_without_image.each do |artist|
        create :recording,   artist: artist, youtube_url: nil
        create :performance, artist: artist, event: events.second
      end
    end

    it 'returns serialized events having artists image and youtube links' do
      get :index, format: :json

      @events = assigns(:events)

      expect(@events.size).to eql(3)
      expect(@events).to include(events.first)
      expect(@events.sort.first.artists.sort).to eql(artists_with_image[0..1].sort)

      expect(response).to be_success
    end

    context 'with countries' do
      it 'returns only events in selected country' do
        get :index, countries: ['Country #0'], format: :json

        @events = assigns(:events)

        expect(@events.size).to eql(1)
        expect(@events.to_a).to eql([events.first])
      end

      it 'returns only events in selected coutries' do
        get :index, countries: ['Country #0', 'Country #1'], format: :json

        @events = assigns(:events)

        expect(@events.size).to eql(2)
        expect(@events).to include(events.first)
        expect(@events).to include(events.second)
      end
    end

    context 'with tags' do
      before :each do
        artists_with_image[0].update_attributes(tags: ['rock', 'pop', 'alternative'])
        artists_with_image[1..2].each { |artist| artist.update_attributes(tags: ['alternative']) }
        artists_with_image[3].update_attributes(tags: ['pop'])
      end

      it 'filters events by tag' do
        get :index, tags: ['alternative'], format: :json

        @events = assigns(:events)

        expect(@events.size).to eql(2)
        expect(@events.to_a.sort).to eql(events[0..1])
      end

      it 'filters events by multiple tags' do
        get :index, tags: ['rock', 'pop'], format: :json

        @events = assigns(:events)

        expect(@events.size).to eql(2)
        expect(@events.to_a.sort).to eql([events[0], events[2]].sort)
      end
    end
  end
end
