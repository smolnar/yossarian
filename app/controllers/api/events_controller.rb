module API
  class EventsController < API::ApplicationController
    def index
      @events = Event
        .includes(:artists, artists: [recordings: [:track]])
        .where.not(recordings: { youtube_url: nil })
        .where.not(artists: { image: nil })
        .where.not(events: { id: Array.wrap(params[:except]) })
        .references(:recordings, :artists)
        .order(performances_count: :desc)
        .limit(6)

      respond_to do |format|
        # TODO (smolnar) sort in sql
        format.json { render json: @events.sort_by { |e| e.artists.size }.reverse }
      end
    end
  end
end
