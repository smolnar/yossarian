#= require spec_helper

describe 'Event', ->
  beforeEach ->
    @date  = new Date()
    @event = Factory.create 'event', title: 'Pohoda 2014', startsAt: @date

  it 'has title', ->
    expect(@event.get('title')).to.eql('Pohoda 2014')

  it 'has start date', ->
    expect(@event.get('startsAt')).to.eql(@date)

  it 'has artists', ->
    artists = []

    Ember.run =>
      3.times => @event.get('artists').pushObject(Factory.create('artist'))

      expect(@event.get('artists.length')).to.eql(3)
