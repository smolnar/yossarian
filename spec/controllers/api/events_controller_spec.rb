require 'spec_helper'

describe API::EventsController do
  describe 'GET index' do
    let!(:artist) { event.artists.first }
    let!(:event) { create :event, :with_artists}
    let!(:recordings) { 2.times.map { create :recording, artist: artist }}

    it 'returns serialzed events' do
      get :index

      expect(response).to be_success

      pending
    end
  end
end
