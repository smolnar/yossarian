require 'spec_helper'

describe EventsController do
  describe 'GET index' do
    let!(:event) { create :event }

    it 'returns serialzed events' do
      get :index

      expect(response.body).to eql({
        events: [
          {
            title: event.title
          }
        ]
      }.to_json)
    end
  end
end
