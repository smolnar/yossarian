Factory.define 'recording', (f) ->
  @association 'artist'
  @association 'track'
