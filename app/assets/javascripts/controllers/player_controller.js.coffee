Yossarian.PlayerController = Ember.Controller.extend
  states: { stopped: 0, playing: 1 }

  artists:          null
  currentRecording: null
  currentState:     0

  recordings: (->
    @get('artists').map((artist) -> artist.get('recordings').toArray().shuffle()[0..1]).flatten().sortBy('id')
  ).property('artists.@each.recordings.@each')

  playing: (->
    @get('currentState') == @get('states.stopped')
  ).property('currentState')

  artistsChanged: (->
    @set('currentRecording', null)
  ).observes('artists.@each')

  play: ->
    @set('currentRecording', @get('lastRecording') || @get('recordings')[0])

  actions: {
    play: -> @set('currentState', @get('states.playing'))
    stop: -> @set('currentState', @get('states.stopped'))
    backward: ->
      # TODO circle
      index = @get('recordings').indexOf(@get('currentRecording'))
      recording = @get('recordings')[index - 1]

      @set('currentRecording', recording) if recording

    forward: ->
      # TODO circle
      index = @get('recordings').indexOf(@get('currentRecording'))
      recording = @get('recordings')[index + 1]

      @set('currentRecording', recording) if recording
  }
