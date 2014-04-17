module Lastfm
  module Events
    extend self

    attr_accessor :downloader, :factory

    def downloader
      @downloader ||= Scout::Downloader
    end

    def factory
      @factory ||= Yossarian::Factory
    end

    def parser
      @parser ||= Lastfm::Events::Parser
    end

    def self.get(params = {})
      params = { format: :json, page: 1 }.merge(params)
      query  = params.map { |key, value| "#{key}=#{value}" }.join('&')
      url    = "#{Lastfm.config.events.url}&#{query}"

      begin
        response = downloader.download(url)
        data     = parser.parse(response)

        events = data[:events][:event]

        events.each do |event|
          factory.create_from_lastfm(event)
        end

        url.gsub!(/page=\d+/, "page=#{data[:@attr][:page] + 1}")
      end while events.any?
    end
  end
end
