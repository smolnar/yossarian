window.build = ->
  @params = arguments

  Ember.run => Factory.build.apply(null, @params)

window.create = ->
  @params = arguments

  Ember.run => Factory.create.apply(null, @params)

window.find = ->
  @params = arguments

  Ember.run => Factory.find.apply(null, @params)
