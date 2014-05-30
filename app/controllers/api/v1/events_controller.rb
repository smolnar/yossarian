module API::V1
  class EventsController < API::V1::ApplicationController
    before_action :compose_filter, only: :search

    def search
      @events = Event
        .includes(:performances, performances: [:event, artist: [recordings: :track]])
        .where(events: { id: @filter.map(&:id) })
        .order(notable_performances_count: :desc)

      render json: @events
    end

    private

    def compose_filter
      @filter = Event
        .joins(:artists, artists: [:recordings])
        .select('events.id, events.performances_count')
        .where('events.starts_at >= ?', Time.zone.now)
        .order(performances_count: :desc)
        .offset(params[:page].to_i * 12)
        .limit(12)
        .uniq

      @filter = @filter.in(params[:countries]) if params[:countries].present?
      @filter = @filter.with(params[:tags]) if params[:tags].present?
      @filter = @filter.search(params[:q]) if params[:q].present?
    end
  end
end
