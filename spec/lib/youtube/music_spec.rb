require 'spec_helper'

describe Youtube::Music do
  describe '.of' do
    subject { described_class }

    it 'finds music video for track' do
      params   = { query: '"Bombay Bicycle Club - Shuffle"', categories: [:music], order_by: :relevance }
      video    = double(:video, state: { name: 'published'}, media_content: [double(:media, url: 'http://url')])
      response = double(:response, videos: [video])

      YouTubeIt::Client.any_instance.stub(:videos_by).with(params) do
        response
      end

      videos = subject.of(artist: 'Bombay Bicycle Club', track: 'Shuffle')

      expect(videos.size).to eql(1)
      expect(videos.first.url).to eql('http://url')
    end
  end
end
