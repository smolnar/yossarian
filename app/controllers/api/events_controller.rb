module API
  class EventsController < API::ApplicationController
    def index
      @events = Event
        .includes(:artists, artists: [recordings: [:track]])
        .where.not(recordings: { youtube_url: nil })
        .references(:recordings)

      respond_to do |format|
        format.json { render json: @events }
      end
    end
  end
end
