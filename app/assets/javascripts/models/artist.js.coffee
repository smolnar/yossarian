Yossarian.Artist = DS.Model.extend
  name:  DS.attr 'string'
  image: DS.attr 'object'

  recordings: DS.hasMany 'recording'
