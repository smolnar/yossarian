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
