import use_test_env from require "lapis.spec"
import request from require "lapis.spec.server"
import truncate_tables from require "lapis.spec.db"

describe "helpers.jwt", ->
  use_test_env!

  it "adds correct padding", ->
    import add_padding from require "helpers.jwt"
    inputs = {
      "YQ"
      "YWI"
      "YWJj"
      "YWJjZA"
      "YWJjZGU"
      "YWJjZGVm"
      "YWJjZGVmZw"
    }

    outputs = {
      "YQ=="
      "YWI="
      "YWJj"
      "YWJjZA=="
      "YWJjZGU="
      "YWJjZGVm"
      "YWJjZGVmZw=="
    }

    for i, str in ipairs inputs
      assert.same outputs[i], add_padding str

