Yossarian.Event = DS.Model.extend
  title:           DS.attr 'string'
  poster:          DS.attr 'object'
  startsAt:        DS.attr 'date'
  endsAt:          DS.attr 'date'
  venue_name:      DS.attr 'string'
  venue_city:      DS.attr 'string'
  venue_country:   DS.attr 'string'
  venue_latitude:  DS.attr 'string'
  venue_longitude: DS.attr 'string'

  performances: DS.hasMany 'performance'

  artists: (->
    @get('performances.@each.artist').uniq()
  ).property('performances.@each.artist')

  shuffledArtists: (->
    artists = @get('artists')
    split   = Math.round(artists.length / 2) - 1

    artists[0..split].shuffle().concat artists[(split + 1)..(length - 1)].shuffle()
  ).property('artists')
