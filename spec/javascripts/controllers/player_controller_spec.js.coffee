#= require spec_helper

describe 'PlayerController', ->
  beforeEach ->
    @event   = create 'event'
    @artists = [
      create('artist'),
      create('artist')
      create('artist')
    ]

    @recordings = []
    @controller = Yossarian.PlayerController.create()

    for artist in @artists
      3.times =>
        recording = create('recording', artist: artist)

        @recordings.push(recording)

    for artist in @artists
      create 'performance', artist: artist, event: @event

    @controller.set('event', @event)

  describe '@artists', ->
    it 'returns current artists', ->
      expect(@controller.get('artists.length')).not.to.eql(0)
      expect(@controller.get('artists')).to.eql(@artists)

    context 'when artists changes', ->
      it 'does not reload artists', ->
        artist = create 'artist'

        create 'performance', artist: artist, event: event

        expect(@controller.get('artists')).to.eql(@artists)

    context 'when event changes', ->
      it 'reloads artists', ->
        event  = create 'event'
        artist = create 'artist'

        create 'performance', artist: artist, event: event

        @controller.set('event', event)

        expect(@controller.get('artists')).to.eql([artist])

  describe '@recordings', ->
    it 'returns randomly sorted sample of recordings from artists', ->
      recordings = @controller.get('recordings')

      recordings.forEach (recording) =>
        expect(@recordings.indexOf(recording)).not.to.eql(-1)

    context 'when recordings changes', ->
      it 'does not reload artists', ->
        recordings = @controller.get('recordings')

        create 'recording', artist: @artists[0]

        expect(@controller.get('recordings.length')).to.eql(recordings.length)

        recordings.forEach (recording) =>
          expect(@recordings.indexOf(recording)).not.to.eql(-1)

    context 'when event changes', ->
      it 'reloads recordings', ->
        event     = create 'event'
        artist    = create 'artist'
        recording = create 'recording', artist: artist

        create 'performance', artist: artist, event: event

        @controller.set('event', event)

        expect(@controller.get('recordings')).to.eql([recording])

  describe '@currentRecording', ->
    it 'returns current recording', ->
      expect(@controller.get('currentRecording')).to.be.a('null')

  describe '#play', ->
    it 'sets current recording', ->
      @controller.play()

      expect(@controller.get('currentRecording')).to.eql(@controller.get('recordings')[0])

  describe 'observers', ->
    describe '+currentStateDidChange', ->
      context 'when current state changes to stopped', ->
        it 'sets current recording to null', ->
          @controller.play()

          expect(@controller.get('currentRecording')).not.to.be.a('null')

          recording = @controller.get('currentRecording')

          @controller.send('stop')

          expect(@controller.get('lastRecording')).to.eql(recording)
          expect(@controller.get('currentRecording')).to.be.a('null')

      context 'when current state changes to playing and current recording is not set', ->
        it 'sets current recording', ->
          @controller.set('currentRecording', null)
          @controller.send('play')

          expect(@controller.get('currentRecording')).to.eql(@controller.get('recordings').toArray()[0])

      context 'when current state changes to playing and last recording is set', ->
        it 'sets current recording as last played', ->
          @controller.play()

          expect(@controller.get('currentRecording')).not.to.be.a('null')

          @controller.send('stop')
          @controller.send('play')
          @controller.send('forward')

          recording = @controller.get('lastRecording')

          expect(@controller.get('recordings').toArray()[1]).to.eql(recording)
          expect(@controller.get('lastRecording')).to.eql(recording)
          expect(@controller.get('currentRecording')).to.eql(recording)

    describe '+currentRecordingDidChange', ->
      context 'when current recoding is present and not already playing', ->
        it 'starts playing', ->
          @controller.set('currentRecording', @controller.get('recordings.firstObject'))

          expect(@controller.get('playing')).to.be.true

      context 'when current recording is not present', ->
        it 'does not start playing', ->
          @controller.send('stop')
          @controller.set('currentRecording', null)

          expect(@controller.get('playing')).to.be.false

  describe 'actions', ->
    describe '+play', ->
      it 'sets current state to playing', ->
        @controller.send('play')

        expect(@controller.get('currentState')).to.eql(@controller.get('states.playing'))

    describe '+stop', ->
      it 'sets the current state to stop', ->
        @controller.send('stop')

        expect(@controller.get('currentState')).to.eql(@controller.get('states.stopped'))

    describe '+backward', ->
      it 'sets current recording to previous one', ->
        recordings = @controller.get('recordings')

        @controller.set('currentRecording', recordings[1])

        @controller.send('backward')

        expect(@controller.get('currentRecording')).to.eql(recordings[0])

      context 'when the recording is the first one', ->
        it 'reloads recordings and sets the first one', ->
          recordings = @controller.get('recordings')

          @controller.set('currentRecording', recordings[0])

          @controller.send('backward')

          expect(@controller.get('currentRecording')).to.eql(recordings[recordings.length - 1])

    describe '+forward', ->
      it 'sets the current recording to next one', ->
        recordings = @controller.get('recordings')

        @controller.set('currentRecording', recordings[0])

        @controller.send('forward')

        expect(@controller.get('currentRecording')).to.eql(recordings[1])

      context 'when the recording is the last one', ->
        it 'reloads recordings and sets the first one', ->
          recordings = @controller.get('recordings')

          @controller.set('currentRecording', recordings[recordings.length - 1])

          @controller.send('forward')

          expect(@controller.get('currentRecording')).to.eql(recordings[0])

    describe '+shuffle', ->
      it 'shuffles recordings for playlist', ->
        recordings = @controller.get('recordings')

        @controller.get('currentRecording', recordings[1])
        @controller.send('shuffle')

        expect(@controller.get('recordings')).not.to.eql(recordings)
        expect(@controller.get('currentRecording')).to.eql(@controller.get('recordings.firstObject'))
