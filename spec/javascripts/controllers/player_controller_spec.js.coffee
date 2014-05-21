#= require spec_helper

describe 'PlayerController', ->
  beforeEach ->
    @artists = [
      create('artist'),
      create('artist')
      create('artist')
    ]

    @recordings = []
    @controller = Yossarian.PlayerController.create()

    @artists.forEach (artist) =>
      3.times =>
        recording = create('recording', artist: artist)

        @recordings.push(recording)

    @controller.set('artists', @artists)

  describe '@artists', ->
    it 'returns current artists', ->
      expect(@controller.get('artists.length')).not.to.eql(0)
      expect(@controller.get('artists')).to.eql(@artists)

  describe '@recordings', ->
    it 'returns randomly sorted sample of recordings from artists', ->
      recordings = @controller.get('recordings')

      recordings.forEach (recording) =>
        expect(@recordings.indexOf(recording)).not.to.eql(-1)

  describe '@currentRecording', ->
    it 'returns current recording', ->
      expect(@controller.get('currentRecording')).to.be.a('null')

  describe '#play', ->
    it 'sets current recording', ->
      @controller.play()

      expect(@controller.get('currentRecording')).to.eql(@controller.get('recordings')[0])

  describe 'observers', ->
    describe '+artistsDidChange', ->
      context 'when artists change', ->
        it 'sets currentRecording to null', ->
          @controller.set('currentRecording', @recordings[0])

          expect(@controller.get('currentRecording')).not.to.be.a('null')

          @controller.set('artists', [])

          expect(@controller.get('currentRecording')).to.be.a('null')

    describe '+currentStateDidChange', ->
      context 'when current state changes to stopped', ->
        it 'sets current recording to null', ->
          @controller.play()

          expect(@controller.get('currentRecording')).not.to.be.a('null')

          @controller.send('stop')

          expect(@controller.get('currentRecording')).to.be.a('null')

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
        it 'reloads recordings and sets the first one'

    describe '+forward', ->
      it 'sets the current recording to next one', ->
        recordings = @controller.get('recordings')

        @controller.set('currentRecording', recordings[0])

        @controller.send('forward')

        expect(@controller.get('currentRecording')).to.eql(recordings[1])

      context 'when the recording is the last one', ->
        it 'reloads recordings and sets the first one'
