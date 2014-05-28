#= require spec_helper

describe 'EventArtistsView', ->
  beforeEach ->
    @view = Yossarian.EventArtistsView.create()

    Ember.run => @view.append()

  afterEach ->
    Ember.run => @view.remove()

  describe 'observers', ->
    describe '+contentDidChange', ->
      it 'sets content by artists randomly', ->
        artists = []

        5.times -> artists.push(create('artist'))

        @view.set('artists', artists)

        content = @view.get('content')

        expect(artists).not.to.eql(content)
        expect(artists.sort).to.eql(content.sort)
