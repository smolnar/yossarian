Ember.Handlebars.registerHelper 'slice', (context, options) ->
  collection = if typeof(context) == 'string' then @get(context) else context
  offset     = parseInt(options.hash.offset) || 0
  limit      = parseInt(options.hash.limit)  || 5

  Handlebars.helpers.each(collection[offset...limit], options)
