require 'spec_helper'

describe API::EventsController do
  describe 'GET index' do
    let!(:artist) { event.artists.first }
    let!(:event) { create :event, :with_artists}
    let!(:recordings) { 2.times.map { create :recording, artist: artist }}

    it 'returns serialized events' do
      get :index, format: :json

      expect(response).to be_success
    end
  end
end
