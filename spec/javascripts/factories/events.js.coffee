RogueGirl.define 'event', (f) ->
  @sequence 'title', (n) -> "Event ##{n}"

  f.startDate = -> new Date()
  f.image     =
    image:
      image:
        small:
          url: 'http://small-image.png'
        large:
          url: 'http://large-image.png'
