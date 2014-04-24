Number::times = (fn) ->
  do fn for [1..@valueOf()]
  return
