Yossarian.PlayerController = Ember.Controller.extend
  states: { stopped: 0, playing: 1 }

  artists:          null
  currentRecording: null
  currentState:     0

  recordings: (->
    @get('artists').map((artist) -> artist.get('recordings').toArray().shuffle()[0..1]).flatten().sortBy('id')
  ).property('artists.@each.recordings.@each')

  playing: (->
    @get('currentState') == @get('states.playing')
  ).property('currentState')

  artistsDidChange: (->
    @set('currentRecording', null)
  ).observes('artists.@each')

  currentStateDidChange: (->
    @set('currentRecording', null) if @get('currentState') == @get('states.stopped')
  ).observes('currentState')

  play: ->
    @set('currentRecording', @get('recordings')[0])
    @send('play')

  actions:
    play: -> @set('currentState', @get('states.playing'))
    stop: -> @set('currentState', @get('states.stopped'))
    backward: ->
      index     = @get('recordings').indexOf(@get('currentRecording'))
      recording = @get('recordings')[index - 1]

      @set('currentRecording', recording) if recording

    forward: ->
      index     = @get('recordings').indexOf(@get('currentRecording'))
      recording = @get('recordings')[index + 1]

      @set('currentRecording', recording) if recording
