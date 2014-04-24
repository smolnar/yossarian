#= require spec_helper

describe 'Event', ->
  it 'has title', ->
    event = Factory.create 'event', title: 'Pohoda 2014'

    expect(event.get('title')).to.eql('Pohoda 2014')

  it 'has start date', ->
    date  = new Date()
    event = Factory.create 'event', title: 'Pohoda 2014', startsAt: date

    expect(event.get('startsAt')).to.eql(date)

  it 'has artists', ->
    event   = Factory.create 'event'
    artists = []

    Ember.run =>
      3.times -> event.get('artists').pushObject Factory.create('artist')

      expect(event.get('artists.length')).to.eql(3)
