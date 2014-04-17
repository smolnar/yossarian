module Lastfm::Events
  module Parser
    def self.parse(data)
      JSON.parse(data, symbolize_names: true)
    end
  end
end
