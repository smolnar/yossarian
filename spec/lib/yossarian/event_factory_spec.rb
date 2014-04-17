require 'spec_helper'

describe Yossarian::EventFactory do
  describe '.create_from_lastfm' do
    it 'creates event' do
      model = double(:event)

      expect(model).to receive(:create_from_lastfm).with(id: '1', title: 'Festival')

      stub_const('Event', model)

      Yossarian::EventFactory.create_from_lastfm(id: '1', title: 'Festival')
    end

    context 'when record is not valid' do
      let!(:record) { Event.new }

      it 'ommits exception' do
        model = double(:event)

        model.stub(:create_from_lastfm) { raise ActiveRecord::RecordInvalid.new(record) }

        stub_const('Event', model)

        Yossarian::EventFactory.create_from_lastfm(id: '1', title: 'Festival')
      end
    end

    context 'when error occurs' do
      it 'propagates error' do
        model = double(:event)

        model.stub(:create_from_lastfm) { raise ArgumentError }

        stub_const('Event', model)

        expect { Yossarian::EventFactory.create_from_lastfm(id: 1, title: 'Festival') }.to raise_error(ArgumentError)
      end
    end
  end
end
