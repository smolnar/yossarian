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
        .uniq

      if params[:countries].present?
        @events = @events.in(params[:countries])
      end

      if params[:tags].present?
        @events = @events.with(params[:tags])
      end

      respond_to do |format|
        format.json { render json: @events }
      end
    end
  end
end
