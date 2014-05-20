window.build = ->
  @params = arguments

  Ember.run => RogueGirl.build.apply(null, @params)

window.create = ->
  @params = arguments

  Ember.run => RogueGirl.create.apply(null, @params)
