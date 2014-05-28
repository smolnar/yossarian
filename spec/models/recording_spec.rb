require 'spec_helper'
require 'models/concerns/recordings/buildable_spec'

describe Recording do
  it_behaves_like Recordings::Buildable

  it 'belongs to artist' do
    pending
  end

  it 'belongs to track' do
    pending
  end

  describe 'callbacks' do
    describe '#update_artists_events!' do
      it 'update artist events' do
        recording = create :recording
        event     = double(:event)

        recording.artist.stub(:events) { [event] }

        expect(event).to receive(:save!)

        recording.save!
      end
    end
  end
end
