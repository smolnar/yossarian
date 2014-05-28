require 'spec_helper'
require 'models/concerns/artists/buildable_spec'

describe Artist do
  it_behaves_like Artists::Buildable

  it 'stores image' do
    DownloaderService.stub(:fetch) { fixture('poster.jpg') }

    artist = create :artist

    expect(artist.image.file).not_to be_nil
  end

  context 'when no image is available' do
    it 'does not store image' do
      DownloaderService.stub(:fetch) { nil }

      artist = create :artist

      expect(artist.image.file).to be_nil
    end
  end

  describe 'callbacks' do
    describe '#update_event!' do
      it 'updates artists events' do
        artist = create :artist
        event  = double(:event)
        events = double(:events, reload: [event])

        artist.stub(:events) { events }

        expect(event).to receive(:save!)

        artist.save!
      end
    end
  end
end
