module Lastfm::Metadata
  module Parser
    def self.parse(data)
      data   = JSON.parse(data, symbolize_names: true) unless data.is_a? Hash
      result = Hash.new
      data   = data[:@attr]

      result[:page]        = data[:page].to_i
      result[:per_page]    = data[:perPage].to_i
      result[:total_pages] = data[:totalPages].to_i
      result[:total]       = data[:total].to_i

      result
    end
  end
end
