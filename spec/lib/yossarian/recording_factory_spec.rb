require 'spec_helper'

describe Yossarian::RecordingFactory do
  describe '.create_from_youtube' do
    it 'creates event' do
      recording = double(:recording, artist: double(:artist, name: 'Bombay Bicycle Club'), track: double(:track, name: 'Shuffle'))

      Youtube::Music.stub(:of).with(artist: 'Bombay Bicycle Club', track: 'Shuffle') do
        [double(:video, url: 'http://url')]
      end

      Recording.stub(:find).with(1) { recording }

      expect(recording).to receive(:update_attributes!).with(youtube_url: 'http://url')

      Yossarian::RecordingFactory.update_from_youtube(1)
    end
  end

  context 'with no video available' do
    it 'ommit creating recording' do
      recording = double(:recording, artist: double(:artist, name: 'Bombay Bicycle Club'), track: double(:track, name: 'Shuffle'))

      Youtube::Music.stub(:of).with(artist: 'Bombay Bicycle Club', track: 'Shuffle') { [] }

      Recording.stub(:find).with(1) { recording }

      expect(recording).not_to receive(:update_attributes!)

      Yossarian::RecordingFactory.update_from_youtube(1)
    end
  end
end
