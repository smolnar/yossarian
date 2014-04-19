Yossarian.Event = DS.Model.extend
  title: DS.attr 'string'
  poster: DS.attr 'object'

  recordings: DS.hasMany 'recording'
