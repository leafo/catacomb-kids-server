import use_test_env from require "lapis.spec"
import truncate_tables from require "lapis.spec.db"

import Scores from require "models"

i = 0
next_hash = ->
  i += 1
  "hash-#{i}"

describe "models.scores", ->
  use_test_env!

  before_each ->
    truncate_tables Scores

  it "creates score", ->
    Scores\create {
      hash: next_hash!
      ip: "127.0.0.1"
      raw_data: {
        player_name: "hello world"
      }
    }

    assert.same 1, Scores\count!
    score = unpack Scores\select!
    assert.same Scores.environments.default, score.environment

