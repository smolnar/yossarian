module Lastfm
  include Squire
end

Lastfm.config do |config|
  config.events do |events|
    events.url = "#{Configuration.lastfm.base}?method=geo.getevents&api_key=#{Configuration.lastfm.apikey}"
  end

  config.artist do |artist|
    artist.url = "#{Configuration.lastfm.base}?method=artist.getinfo&api_key=#{Configuration.lastfm.apikey}"

    artist.tracks do |tracks|
      tracks.url = "#{Configuration.lastfm.base}?method=artist.gettoptracks&api_key=#{Configuration.lastfm.apikey}"
    end
  end
end

require 'lastfm/metadata/parser'
require 'lastfm/events/parser'
require 'lastfm/events'
require 'lastfm/artist/parser'
require 'lastfm/artist'
