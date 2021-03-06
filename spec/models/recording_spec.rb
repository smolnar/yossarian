require 'spec_helper'

describe Recording do
  it 'belongs to artist' do
    pending
  end

  it 'belongs to track' do
    pending
  end

  describe 'callbacks' do
    describe '#update_artists_events!' do
      it 'update artist events' do
        event     = double(:event)
        events    = double(:events, reload: [event])
        recording = create :recording

        recording.artist.stub(:events) { events }

        expect(event).to receive(:save!)

        recording.save!
      end
    end
  end
end
