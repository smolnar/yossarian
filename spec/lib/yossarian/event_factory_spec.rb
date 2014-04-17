require 'spec_helper'

describe Yossarian::EventFactory do
  describe '.create_from_lastfm' do
    it 'creates event' do
      Lastfm::Event::Parser.stub(:parse).with({ id: '1', some_title_attribute: 'Festival' }.to_json) do
        { id: '1', title: 'Festival' }
      end

      model = double(:event)

      expect(model).to receive(:create_from_lastfm).with(id: '1', title: 'Festival')

      stub_const('Event', model)

      Yossarian::EventFactory.create_from_lastfm(id: '1', some_title_attribute: 'Festival')
    end
  end
end
