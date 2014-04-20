Yossarian.PlayerController = Ember.Controller.extend
  artists: null
  currentRecording: null
  lastRecording:    null

  recordings: (->
    @get('artists').toArray().map((artist) -> artist.get('recordings')).flatten().uniq().shuffle()
  ).property('artists.@each.recordings.@each')

  playing: (->
    @get('currentRecording')?
  ).property('currentRecording')

  currentRecordingChanged: (->
    @set('lastRecording', @get('currentRecording')) if @get('currentRecording')
  ).observes('currentRecording')

  artistsChanged: (->
    @set('lastRecording', null)
  ).observes('artists.@each')

  play: ->
    @set('currentRecording', @get('lastRecording') || @get('recordings')[0])

  actions: {
    play: -> @play()
    stop: -> @set('currentRecording', null)
    backward: ->
      index = @get('recordings').indexOf(@get('lastRecording'))
      recording = @get('recordings')[index - 1]

      @set('currentRecording', recording) if recording

    forward: ->
      index = @get('recordings').indexOf(@get('lastRecording'))
      recording = @get('recordings')[index + 1]

      @set('currentRecording', recording) if recording
  }
