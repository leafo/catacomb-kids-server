import use_test_env from require "lapis.spec"
import truncate_tables from require "lapis.spec.db"

import Scores from require "models"

describe "models.scores", ->
  use_test_env!

  before_each ->
    truncate_tables Scores

  it "creates score", ->
    Scores\create {
      raw_data: {
        player_name: "hello world"
      }
    }

    assert.same 1, Scores\count!

