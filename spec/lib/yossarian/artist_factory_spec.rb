require 'spec_helper'

describe Yossarian::ArtistFactory do
  describe '.create_from_lastfm' do
    it 'creates event' do
      model = double(:event)

      expect(model).to receive(:create_from_lastfm).with(id: '1', title: 'Festival')

      stub_const('Event', model)

      Yossarian::EventFactory.create_from_lastfm(id: '1', title: 'Festival')
    end
  end
end
