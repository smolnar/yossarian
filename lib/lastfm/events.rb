module Lastfm
  module Events
    extend self

    attr_accessor :downloader, :factory, :parser

    def downloader
      @downloader ||= Scout::Downloader
    end

    def factory
      @factory ||= Yossarian::EventFactory
    end

    def parser
      @parser ||= Lastfm::Events::Parser
    end

    def get(params = {})
      params = { page: 1 }.merge(params)
      query  = params.map { |key, value| "#{key}=#{value}" }.join('&')
      url    = "#{Lastfm.config.events.url}&format=json&#{query}"

      begin
        response         = downloader.download(url)
        metadata, events = parser.parse(response)

        events.each do |event|
          factory.create_from_lastfm(event)
        end

        url.gsub!(/page=\d+/, "page=#{metadata[:page] + 1}")
      end while metadata[:page] < metadata[:total_pages]
    end
  end
end
