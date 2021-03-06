require 'spec_helper'

describe EventSerializer do
  let!(:artist) { event.artists.first }
  let!(:artists) { event.artists }
  let!(:performances) { event.performances.order(id: :desc) }
  let!(:event) { create :event, :with_artists }
  let!(:recordings) { 2.times.map { create :recording, artist: artist }}
  let!(:tracks) { recordings.map(&:track).uniq }

  it 'serializes event' do
    serializer = EventSerializer.new(event)

    expect(serializer.to_json).to be_json_including({
      performances: [
        {
          id: performances[0].id,
          artist_id: performances[0].artist.id,
          event_id: performances[0].event.id
        },
        {
          id: performances[1].id,
          artist_id: performances[1].artist.id,
          event_id: performances[1].event.id
        }
      ],

      artists: [
        {
          id: artists[0].id,
          name: artists[0].name,
          image: {
            image: {
              url: artists[0].image.url,
              small: {
                url: artists[0].image.small.url
              },
              large: {
                url: artists[0].image.large.url
              }
            }
          },
          recording_ids: artists[0].recordings.map(&:id).sort
        },
        {
          id: artists[1].id,
          name: artists[1].name,
          image: {
            image: {
              url: artists[1].image.url,
              small: {
                url: artists[1].image.small.url
              },
              large: {
                url: artists[1].image.large.url
              }
            }
          },
          recording_ids: artists[1].recordings.map(&:id).sort
        },
        {
          id: artists[2].id,
          name: artists[2].name,
          image: {
            image: {
              url: artists[2].image.url,
              small: {
                url: artists[2].image.small.url
              },
              large: {
                url: artists[2].image.large.url
              }
            }
          },
          recording_ids: artists[2].recordings.map(&:id).sort
        },

      ],

      recordings: [
        {
          id: recordings[0].id,
          youtube_url: recordings[0].youtube_url,
          artist_id: artist.id,
          track_id:  recordings[0].track.id
        },
        {
          id: recordings[1].id,
          youtube_url: recordings[1].youtube_url,
          artist_id: artist.id,
          track_id:  recordings[1].track.id
        },
      ],

      tracks: [
        {
          id: tracks[0].id,
          name: tracks[0].name
        },

        {
          id: tracks[1].id,
          name: tracks[1].name
        }
      ],

      event: {
        id: event.id,
        title: event.title,
        performance_ids: performances.pluck(:id)
      },
    })
  end
end
