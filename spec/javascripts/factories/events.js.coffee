RogueGirl.define 'event', (f) ->
  @sequence 'title', (n) -> "Event ##{n}"

  f.startDate = -> new Date()
