# https://gist.github.com/mehulkar/3232255

Ember.ArrayProxy.prototype.flatten = Array.prototype.flatten = ->
  result = []

  @forEach (element) ->
    result.push.apply result, if Ember.isArray(element) then element.toArray().flatten() else [element]

  result

Ember.ArrayProxy.prototype.compact = Array.prototype.compact = ->
  result = []

  @forEach (element) ->
    if element
      result.push.apply result, if Ember.isArray(element) then element.toArray().compact() else [element]

  result
