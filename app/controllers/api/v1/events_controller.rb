module API::V1
  class EventsController < API::V1::ApplicationController
    before_action :compose_filter, only: :search

    def search
      @events = Event
        .includes(:performances, performances: [:event, artist: [recordings: :track]])
        .where(events: { id: @filter })
        .where.not(recordings: { youtube_url: nil })
        .where.not(artists: { image: nil })
        .order(notable_performances_count: :desc)
        .offset(params[:page].to_i * 24)
        .limit(24)

      respond_to do |format|
        format.json { render json: @events }
      end
    end

    private

    def compose_filter
      @filter = Event
        .joins(:artists).joins(:recordings)
        .where.not(recordings: { youtube_url: nil })
        .where.not(artists: { image: nil })
        .uniq

      @filter = @filter.in(params[:countries]) if params[:countries].present?
      @filter = @filter.with(params[:tags]) if params[:tags].present?
      @filter = @filter.search(params[:q]) if params[:q].present?
    end
  end
end
