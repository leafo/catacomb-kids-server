import use_test_server from require "lapis.spec"
import request from require "lapis.spec.server"
import truncate_tables from require "lapis.spec.db"

import Scores from require "models"

factory = require "spec.factory"

build_jwt = (data, secret) ->
  secret or= require("lapis.config").get!.jwt.secret
  header = { typ: "JWT", alg: "HS256" }
  import to_json from require "lapis.util"
  import encode_base64 from require "lapis.util.encoding"
  import hmac_sha256 from require "helpers.jwt"

  left = encode_base64(to_json header) .. "." .. encode_base64(to_json data)
  right = encode_base64 hmac_sha256 secret, left
  "#{left}.#{right}"

valid_score = {
  version_major: 1
  version_minor: 0
  version_patch: 0

  floor_reached: 1
  total_gold: 243
  play_time: 1234
  final_score: 999
  total_kills: 666
  player_name: "King Doofus"
  base_class: "bully"
  about_kid: {}
}

describe "applications.api1", ->
  use_test_server!

  before_each ->
    truncate_tables Scores

  assert_has_error = (res, err) ->
    assert.truthy res.errors
    if err
      assert.same err, res.errors[1]

  describe "submit", ->
    it "attempts to submit invalid data", ->
      status, res = request "/api/1/save-score", {
        method: "POST"
        data: [[hello world]]
        expect: "json"
      }

      assert.same 403, status
      assert_has_error res, "invalid base64"

    it "attempts to submit with invalid secret", ->
      status, res = request "/api/1/save-score", {
        method: "POST"
        data: build_jwt { content: "{}" }, "whwefwef"
        expect: "json"
      }

      assert.same 403, status
      assert_has_error res, "invalid signature"

    it "attempts to submit with invalid content", ->
      status, res = request "/api/1/save-score", {
        method: "POST"
        data: build_jwt { content: "this is not json" }
        expect: "json"
      }

      assert.same 400, status
      assert_has_error res, "content is not json"

    it "submits score", ->
      import to_json from require "lapis.util"

      status, res = request "/api/1/save-score", {
        method: "POST"
        data: build_jwt { content: to_json valid_score }
        expect: "json"
      }

      assert.same 200, status
      assert.same { success: true }, res

      score = assert unpack Scores\select!
      assert.same score.environment, Scores.environments.default

    it "submits score with test environment", ->
      import to_json from require "lapis.util"

      status, res = request "/api/1/save-score?environment=test", {
        method: "POST"
        data: build_jwt { content: to_json valid_score }
        expect: "json"
      }

      assert.same 200, status
      assert.same { success: true }, res

      score = assert unpack Scores\select!
      assert.same score.environment, Scores.environments.test

    it "fails to submit score with incorrect structure", ->
      import to_json from require "lapis.util"
      score = {
        version_major: "hello"
      }

      status, res = request "/api/1/save-score", {
        method: "POST"
        data: build_jwt { content: to_json score }
        expect: "json"
      }

      assert.same 400, status
      assert.not.same { success: true }, res

  describe "list", ->
    it "gets empty list", ->
      status, res = request "/api/1/list", {
        method: "GET"
        expect: "json"
      }

      assert.same 200, status
      assert.same { scores: {}}, res

    it "gets list with scores", ->
      for i=1,3
        factory.Scores!

      status, res = request "/api/1/list", {
        method: "GET"
        expect: "json"
      }

      assert.same 200, status
      assert.same { scores: {
        {player_name: "hello world"}
        {player_name: "hello world"}
        {player_name: "hello world"}
      }}, res

