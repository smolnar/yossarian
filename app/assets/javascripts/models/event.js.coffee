Yossarian.Event = DS.Model.extend
  title: DS.attr 'string'

  recordings: DS.hasMany 'recording'
