Yossarian.Artist = DS.Model.extend
  name:  DS.attr 'string'
  image: DS.attr 'object'

  performances: DS.hasMany 'performance'
  recordings:   DS.hasMany 'recording'

  events: (->
    @get('performances.@each.event').uniq()
  ).property('performances.@each.event')
