class DownloaderService
  def self.fetch(urls)
    urls.each do |url|
      response = Scout::Downloader.download(url, with_response: true)

      if response.response_code == 200
        file = Tempfile.new('downloader-service', encoding: 'ascii-8bit')

        file.write(response.body_str)
        file.rewind

        return file
      end
    end
  end
end
