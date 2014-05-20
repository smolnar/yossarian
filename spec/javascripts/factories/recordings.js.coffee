#= require factories/artists
#= require factories/tracks

RogueGirl.define 'recording', (f) ->
  @association 'artist'
  @association 'track'
