module Events
  module Geocodeable
    extend ActiveSupport::Concern

    included do
      unless Rails.env.test?
        reverse_geocoded_by :venue_latitude, :venue_longitude do |record, results|
          if data = results.first
            record.venue_city    = data.city unless record.venue_city.present?
            record.venue_country = data.country unless record.venue_country.present?
          end
        end
      end
    end
  end
end
