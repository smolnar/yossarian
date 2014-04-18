Yossarian.Recording = DS.Model.extend
  youtube_url: DS.attr 'string'

  artist: DS.belongsTo 'artist'
  track:  DS.belongsTo 'track'
