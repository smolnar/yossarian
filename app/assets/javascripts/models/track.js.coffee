Yossarian.Track = DS.Model.extend
  name: DS.attr 'string'

  recordings: DS.hasMany 'recording'
