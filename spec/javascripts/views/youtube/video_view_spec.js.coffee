#= require spec_helper

describe 'YoutubeVideoView', ->
  beforeEach ->
    player      = mock(setVolume: (->), setPlaybackQuality: (->), loadVideoByUrl: (->))
    controller  = mock(send: ->)
    @player     = player.mock
    @controller = controller.mock
    @view       = Yossarian.YoutubeVideoView.create()
    window.YT   = { Player: (-> player.object), PlayerState: { ENDED: 1 } }

    @view.set('player', player.object)
    @view.set('controller', controller.object)

  describe '#stateDidChange', ->
    context 'when state changes', ->
      it 'sets defaults for player', ->
        @player.expects('setPlaybackQuality').withExactArgs('hd720').once()
        @player.expects('setVolume').withExactArgs(100).once()

        @view.stateDidChange({})

    context 'when player ended', ->
      it 'sends event to controller to play next song', ->
        @player.expects('setPlaybackQuality').withExactArgs('hd720').once()
        @player.expects('setVolume').withExactArgs(100).once()
        @controller.expects('send').withExactArgs('forward').once()

        @view.stateDidChange(data: YT.PlayerState.ENDED)

  describe 'observers', ->
    describe '+urlDidChange', ->
      context 'when url changes', ->
        it 'loads video by url', ->
          @player.expects('loadVideoByUrl').withExactArgs('http://youtu.be').once()
          @view.set('url', 'http://youtu.be')
