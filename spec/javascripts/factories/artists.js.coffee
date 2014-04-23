Factory.define 'artist', (f) ->
  @sequence 'name', (n) -> "Artist ##{n}"
