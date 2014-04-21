Yossarian.YoutubeVideoView = Ember.View.extend
  tagName: 'div'
  attributeBindings: ['height', 'width', 'url']

  height: 200
  width:  300

  didInsertElement: -> @renderPlayer()

  setUrl: -> @get('player').loadVideoByUrl(@get('url'))

  renderPlayer: ->
    player = new YT.Player(@$().attr('id'),
      height: @get('height')
      width: @get('width')
      playerVars:
          autoplay: 1
          controls: 1
      events:
        onReady: => @setUrl()
        onStateChange: (event) => @stateDidChange(event)
    )

    @set('player', player)

  stateDidChange: (event) ->
    @get('player').setPlaybackQuality('hd720')
    @get('player').setVolume(100)
    @get('controller').send('forward') if event.data == YT.PlayerState.ENDED

  urlDidChange: (->
    @setUrl()
  ).observes('url')
