module API
  class EventsController < ApplicationController
    def index
      @events = Event.includes(:artists, :recordings, :tracks)

      render json: @events
    end
  end
end
