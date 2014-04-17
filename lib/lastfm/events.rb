module Lastfm
  module Events
    extend self

    attr_accessor :downloader, :factory

    def downloader
      @downloader ||= Scout::Downloader
    end

    def factory
      @factory ||= Yossarian::EventFactory
    end

    def get(params = {})
      params = { page: 1 }.merge(params)
      query  = params.map { |key, value| "#{key}=#{value}" }.join('&')
      url    = "#{Lastfm.config.events.url}&format=json&#{query}"

      begin
        response = downloader.download(url)
        data     = JSON.parse(response, symbolize_names: true)
        events   = data[:events][:event]

        events.each do |event|
          factory.create_from_lastfm(event)
        end

        url.gsub!(/page=\d+/, "page=#{data[:events][:@attr][:page].to_i + 1}")
      end while events.any?
    end
  end
end
