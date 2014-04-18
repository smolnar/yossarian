require 'spec_helper'

describe Yossarian::RecordingFactory do
  describe '.create_from_youtube' do
    it 'creates event' do
      model = double(:recording)

      Youtube::Music.stub(:of).with(artist: 'Bombay Bicycle Club', track: 'Shuffle') do
        [double(:video, url: 'http://url')]
      end

      expect(model).to receive(:create_from_youtube).with(artist: 'Bombay Bicycle Club', track: 'Shuffle', url: 'http://url')

      stub_const('Recording', model)

      Yossarian::RecordingFactory.create_from_youtube(artist: 'Bombay Bicycle Club', track: 'Shuffle')
    end
  end

  context 'with no video available' do
    it 'ommit creating recording' do
      model = double(:recording)

      Youtube::Music.stub(:of).with(artist: 'Bombay Bicycle Club', track: 'Shuffle') { [] }

      stub_const('Recording', model)

      Yossarian::RecordingFactory.create_from_youtube(artist: 'Bombay Bicycle Club', track: 'Shuffle')
    end
  end
end
