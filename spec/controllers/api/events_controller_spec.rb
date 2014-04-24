require 'spec_helper'

describe API::EventsController do
  describe 'GET index' do
    let(:events) { 3.times.map { create :event } }
    let(:artists_with_image) { 3.times.map { create :artist, image: fixture('poster.jpg') }}
    let(:artists_without_image) { 3.times.map { create :artist, image: nil }}

    before :each do
      artists_with_image[0..1].each do |artist|
        create :recording,   artist: artist
        create :performance, artist: artist, event: events.first
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

      expect(@events.size).to eql(1)
      expect(@events.first).to eql(events.first)
      expect(@events.first.artists.sort).to eql(artists_with_image[0..1].sort)

      expect(response).to be_success
    end
  end
end
