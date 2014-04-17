module Yossarian
  module EventFactory
    def self.create_from_lastfm(data)
      Worker.perform_async(data.to_json)
    end

    class Worker
      include Sidekiq::Worker

      sidekiq_options queue: :events, backtrace: true

      def perform(data)
        attributes = Lastfm::Event::Parser.parse(data)

        begin
          ::Event.create_from_lastfm(attributes.to_h)
        rescue ActiveRecord::RecordInvalid => e
          puts "#{attributes[:title]}: #{e.message}"
        end
      end
    end
  end
end
