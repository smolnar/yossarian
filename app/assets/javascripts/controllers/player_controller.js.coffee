Yossarian.PlayerController = Ember.Controller.extend
  states: { stopped: 0, playing: 1 }

  event:            null
  artists:          null
  currentRecording: null
  currentState:     0

  artists: (->
    @get('event.artists')
  ).property('event')

  recordings: (->
    @get('artists').map((artist) -> artist.get('recordings').toArray().shuffle()[0..1]).flatten().compact()
  ).property('event')

  playing: (->
    @get('currentState') == @get('states.playing')
  ).property('currentState')

  currentRecordingDidChange: (->
    @send('play') if @get('currentRecording') && !@get('playing')
  ).observes('currentRecording')

  currentStateDidChange: (->
    @set('currentRecording', null) if @get('currentState') == @get('states.stopped')

    if @get('currentState') == @get('states.playing') && !@get('currentRecording')
      @set('currentRecording', @get('recordings.firstObject'))
  ).observes('currentState')

  play: ->
    @set('currentRecording', @get('recordings.firstObject'))

  actions:
    play: -> @set('currentState', @get('states.playing'))
    stop: -> @set('currentState', @get('states.stopped'))
    backward: ->
      index     = @get('recordings').indexOf(@get('currentRecording'))
      recording = @get('recordings')[index - 1]

      if recording
        @set('currentRecording', recording) if recording
      else
        @set('currentRecording', @get('recordings.lastObject'))

    forward: ->
      index     = @get('recordings').indexOf(@get('currentRecording'))
      recording = @get('recordings')[index + 1]

      if recording
        @set('currentRecording', recording) if recording
      else
        @set('currentRecording', @get('recordings.firstObject'))

    shuffle: ->
      @notifyPropertyChange('recordings')

      @set('currentRecording', @get('recordings.firstObject'))
