#= require sinon
#= require application
#= require_tree ./support
#= require_tree ./factories

mocha.ui('bdd')
mocha.globals(['Ember', 'DS', 'App', 'MD5'])
mocha.timeout(0)
chai.Assertion.includeStack = true

# Useful for placing local test vars
window.Test ||= {}

# Shorthand
window.T = Test

# Shorthand for Yossarian
window.App = Yossarian

# Ember lookup
window.helper =
  container: Yossarian.__container__

  lookup: (name) ->
    name = "#{name}:main" unless name.match(':')

    helper.container.lookup(name)

# I want Chai to include stacktraces
ENV =
  TESTING: true

# Keep App in Konacha Iframe
Konacha.reset = Ember.K

# Avoid changes on the browser's URL
App.Router.reopen location: 'none'

# Prevent automatic scheduling of runloops. For tests, we
# want to have complete control of runloops.
Ember.testing = true

# Setup Ember test environment
App.setupForTesting()
App.injectTestHelpers()

Ember.Test.adapter       = Ember.Test.MochaAdapter.create()
Ember.ApplicationAdapter = DS.FixtureAdapter.create()

$.fx.off = true

# Setup
beforeEach (done) ->
  # Global store shorthand
  window.store = helper.lookup 'store:main'

  Factory.EmberStoreDriver.store = store

  Factory.driver = Factory.EmberStoreDriver

  # Fake XHR with Sinon
  window.server = sinon.fakeServer.create()

  # Reset all test variables
  window.Test = {}

  try
    Ember.run(App, App.advanceReadiness)
  catch error
    console.error("Error during example teardown: #{Ember.inspect(error)}")

  Ember.run -> done()

afterEach ->
  # Reset App
  try
    Ember.run -> App.reset()
  catch error
    console.error("Error during example teardown: #{Ember.inspect(error)}")

  # Reset all test variables
  window.Test = {}

  # Restore XHR
  window.server.restore()
