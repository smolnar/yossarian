require 'spec_helper'

describe EventSerializer do
  let!(:artist) { event.artists.first }
  let!(:event) { create :event, :with_artists}
  let!(:recordings) { 2.times.map { create :recording, artist: artist }}

  before :each do
    create :recording, artist: artist, youtube_url: nil
  end

  it 'serializes event' do
    serializer = EventSerializer.new(event)

    expect(serializer.to_json).to eql_as_json({
      event: {
        title: event.title,
        recording_ids: recordings.map(&:id)
      },

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
      ]
    })
  end
end
