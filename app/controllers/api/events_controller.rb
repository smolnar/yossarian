module API
  class EventsController < ApplicationController
    def index
      @events = Event.includes(:artists, :recordings, :tracks).last(5)

      render json: @events
    end
  end
end
