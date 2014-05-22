module API::V1
  class EventsController < API::V1::ApplicationController
    def search
      @events = Event
        .includes(:performances, performances: [:event, artist: [recordings: :track]])
        .where.not(recordings: { youtube_url: nil })
        .where.not(artists: { image: nil })
        .references(:recordings, :artists)
        .order(performances_count: :desc)
        .offset(params[:page].to_i * 12)
        .limit(12)

      if params[:countries].present?
        @events = @events.in(params[:countries])
      end

      if params[:tags].present?
        @events = @events.with(params[:tags])
      end

      if params[:q].present?
        @events = @events.search_by(params[:q])
      end

      respond_to do |format|
        format.json { render json: @events }
      end
    end
  end
end
