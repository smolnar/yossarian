Yossarian.Recording = DS.Model.extend
  youtubeUrl: DS.attr 'string'

  artist: DS.belongsTo 'artist'
  track:  DS.belongsTo 'track'
