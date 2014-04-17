module Lastfm
  include Squire
end

Lastfm.config do |config|
  config.events do |events|
    events.url = "#{Configuration.lastfm.base}?method=geo.getevents&api_key=#{Configuration.lastfm.apikey}"
  end
end

require 'lastfm/event/parser'
require 'lastfm/events/parser'
require 'lastfm/events'
