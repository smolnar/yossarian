#= require factories/artists
#= require factories/events

RogueGirl.define 'performance', ->
  @association 'artist'
  @association 'event'
