require 'spec_helper'

describe DownloaderService do
  describe '.fetch' do
    it 'fetches the first available file' do
      urls = [
        'http://invalid-url',
        'http://valid-url',
        'http://unprocessed-url'
      ]

      Scout::Downloader.stub(:download).with(urls.first, with_response: true) { double(:response, response_code: 404) }
      Scout::Downloader.stub(:download).with(urls.second, with_response: true) { double(:response, body_str: 'image', response_code: 200) }

      file = DownloaderService.fetch(urls)

      expect(file.read).to eql('image')
    end
  end
end
