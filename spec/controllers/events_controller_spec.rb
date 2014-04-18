require 'spec_helper'

describe EventsController do
  describe 'GET index' do
    let!(:artist) { event.artists.first }
    let!(:event) { create :event, :with_artists}
    let!(:recordings) { 2.times.map { create :recording, artist: artist }}

    it 'returns serialzed events' do
      get :index

      expect(response.body).to eql({
        recordings: [
          {
            youtube_url: recordings[0].youtube_url,
            artist_id: artist.id,
            track_id:  recordings[0].track.id
          },
          {
            youtube_url: recordings[1].youtube_url,
            artist_id: artist.id,
            track_id:  recordings[1].track.id
          },
        ],

        events: [
          {
            title: event.title,
            recording_ids: recordings.map(&:id)
          }
        ]
      }.to_json)
    end
  end
end
