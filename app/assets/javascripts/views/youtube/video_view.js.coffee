Yossarian.YoutubeVideoView = Ember.View.extend
  tagName: 'div'
  attributeBindings: ['height', 'width', 'url']

  height: 200
  width:  300

  didInsertElement: ->
    @renderPlayer()

  renderPlayer: ->
    player = new YT.Player(@$().attr('id'),
      height: @get('height')
      width: @get('width')
      playerVars:
          autoplay: 1
          controls: 0
      events:
        onReady: => @setUrl()
    )

    @set('player', player)

  setUrl: ->
    @get('player').loadVideoByUrl(mediaContentUrl: @get('url'), suggestedQuality: 'hd720')

  urlChanged: (->
    @setUrl()
  ).observes('url')
