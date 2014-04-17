module Yossarian
  module EventFactory
    def self.create_from_lastfm(data)
      Worker.perform_async(data.to_json)
    end

    class Worker
      include Sidekiq::Worker

      sidekiq_options queue: :events, backtrace: true

      def perform(data)
        attributes = JSON.parse(data, symbolize_names: true)

        begin
          ::Event.create_from_lastfm(attributes)
        rescue ActiveRecord::RecordInvalid
        end
      end
    end
  end
end
