module API
  class EventsController < API::ApplicationController
    def index
      @events = Event
        .includes(:artists, artists: [recordings: [:track]])
        .where.not(recordings: { youtube_url: nil })
        .where.not(artists: { image: nil })
        .references(:recordings, :artists)
        .limit(20)

      respond_to do |format|
        # TODO (smolnar) sort in sql
        format.json { render json: @events.sort_by { |e| e.artists.size }.reverse }
      end
    end
  end
end
