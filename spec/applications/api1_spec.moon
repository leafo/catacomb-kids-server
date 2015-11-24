import use_test_server from require "lapis.spec"
import request from require "lapis.spec.server"
import truncate_tables from require "lapis.spec.db"

import Scores from require "models"

describe "applications.api1", ->
  use_test_server!

  before_each ->
    truncate_tables Scores

  it "submits a score", ->
    status, res = request "/api/1/save-score", {
      method: "POST"
      data: "hello world"
      expect: "json"
    }

    error res
