import use_test_server from require "lapis.spec"
import request from require "lapis.spec.server"
import truncate_tables from require "lapis.spec.db"

import Scores from require "models"

build_jwt = (data, secret) ->
  secret or= require("lapis.config").get!.jwt.secret
  header = { typ: "JWT", alg: "HS256" }
  import to_json from require "lapis.util"
  import encode_base64 from require "lapis.util.encoding"
  import hmac_sha256 from require "helpers.jwt"

  left = encode_base64(to_json header) .. "." .. encode_base64(to_json data)
  right = encode_base64 hmac_sha256 secret, left
  "#{left}.#{right}"

describe "applications.api1", ->
  use_test_server!

  before_each ->
    truncate_tables Scores

  assert_has_error = (res, err) ->
    assert.truthy res.errors
    if err
      assert.same err, res.errors[1]

  it "attempts to submit invalid data", ->
    status, res = request "/api/1/save-score", {
      method: "POST"
      data: [[hello world]]
      expect: "json"
    }

    assert_has_error res, "invalid base64"

  it "attempts to submit with invalid secret", ->
    status, res = request "/api/1/save-score", {
      method: "POST"
      data: build_jwt { content: "{}" }, "whwefwef"
      expect: "json"
    }

    assert_has_error res, "invalid signature"

  it "attempts to submit with invalid content", ->
    status, res = request "/api/1/save-score", {
      method: "POST"
      data: build_jwt { content: "this is not json" }
      expect: "json"
    }

    assert_has_error res, "content is not json"
