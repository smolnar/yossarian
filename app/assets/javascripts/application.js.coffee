#= require jquery
#= require jquery_ujs
#= require foundation

#= require handlebars
#= require ember
#= require ember-data
#= require_self
#= require yossarian

window.Yossarian = Ember.Application.create(rootElement: '#yossarian')

$ -> $(document).foundation()
