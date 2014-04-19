Yossarian.Event = DS.Model.extend
  title:           DS.attr 'string'
  poster:          DS.attr 'object'
  venue_latitude:  DS.attr 'string'
  venue_longitude: DS.attr 'string'

  artists: DS.hasMany 'artist'
