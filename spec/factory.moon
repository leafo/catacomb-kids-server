
models = require "models"

i = 0
next_hash = ->
  i += 1
  "hash-#{i}"

Scores = (opts={}) ->
  opts.hash or= next_hash!
  opts.ip or= "127.0.0.1"
  opts.raw_data or= {
    player_name: "hello world"
  }

  models.Scores\create opts

{ :Scores }
