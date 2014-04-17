module Yossarian
  module EventFactory
    def self.create_from_lastfm(data)
      attributes = Lastfm::Event::Parser.parse(data)

      ::Event.create_from_lastfm(attributes.to_h)
    end
  end
end
