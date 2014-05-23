Ember.Handlebars.registerHelper 'format-date', (value, options) ->
  date = if typeof(value) == 'string' then @get(value) else value

  moment(date).format('MMMM Do, YYYY')
