import use_test_env from require "lapis.spec"
import request from require "lapis.spec.server"
import truncate_tables from require "lapis.spec.db"

describe "helpers.jwt", ->
  use_test_env!

  import parse_jwt, add_padding from require "helpers.jwt"

  it "adds correct padding", ->
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

  it "parses jwt", ->
    input = [[eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjk4MjM0OTgyNzM0LCJleHAiOjkyODM3NDk4NzMyNCwiY29udGVudCI6IntcInZlcnNpb25fbWFqb3JcIjowLFwidmVyc2lvbl9taW5vclwiOjIsXCJ2ZXJzaW9uX3BhdGNoXCI6NixcInZlcnNpb25fc3VmZml4XCI6XCJhXCIsXCJwbGF5ZXJfbmFtZVwiOlwianVuaW9y44Gh44KD44KTXCIsXCJiYXNlX2NsYXNzXCI6XCJ3YW5kZXJlclwiLFwiZmxvb3JfcmVhY2hlZFwiOjMsXCJwbGF5X3RpbWVcIjo1MDAsXCJ0b3RhbF9raWxsc1wiOjE5LFwidG90YWxfZ29sZFwiOjUwMCxcImZpbmFsX3Njb3JlXCI6MTIsXCJkYWlseV9ydW5fZGF5XCI6XCIyMDE2LTAyLTIyXCIsXCJhYm91dF9raWRcIjp7XCJuYW1lXCI6XCJUaG9tIE1hZ3NvblwiLFwiY2xhc3NcIjpcImtpbGxlclwiLFwibGV2ZWxcIjo0LFwic3RhdHNcIjp7XCJTVFJcIjo0LFwiREVGXCI6OSxcIlNQRFwiOjMsXCJNQUdcIjo3LFwiSU5UXCI6NixcIkxVQ1wiOjEyfSxcIm1heCBIUFwiOjI0LFwibWF4IGVuZXJneVwiOjEyLFwiYm9vbnNcIjpbXCJmcmVlcnVuXCIsXCJoZWF2eSBsaWZ0aW5nXCJdLFwidHJhaXRzXCI6W1wiaGF0ZXMgc3dvcmRzXCIsXCJiYWQgc3dpbW1lclwiXSxcInJlcHV0YXRpb25zXCI6W1widmVnZXRhcmlhblwiLFwiaW5ub2NlbnRcIixcIm9yYmxlc3NcIixcInVuZGVycG93ZXJlZCB4M1wiXSxcInNwZWxscyBsZWFybmVkXCI6W1wicGxhZ3VlXCIsXCJhaXJkYXNoXCJdLFwic2tpbiBjb2xvclwiOlwiMHgyZjUzOTBcIixcInNleFwiOlwibWFsZVwiLFwiZXF1aXBtZW50XCI6W3tcIml0ZW1cIjpcImhhdFwiLFwidHlwZVwiOlwiaGVhZFwiLFwicHJvcGVydGllc1wiOltcInBvaXNvbm91c1wiLFwicG9pbnR5XCJdfSx7XCJpdGVtXCI6XCJzaG9lc1wiLFwidHlwZVwiOlwiZm9vdFwiLFwicHJvcGVydGllc1wiOltdfV0sXCJraWxsc1wiOntcImdydW1idWxcIjozLFwiYnlhdFwiOjE3LFwic2xpbWVcIjoyLFwibmFtZWRfZW5lbWllc1wiOltcIk9nIHRoZSB0YXN0eVwiLFwiVGhvY2ssIHNvbiBvZiBPZ1wiXX0sXCJkZWF0aCBtZXNzYWdlXCI6XCJzbGFpbiBieSBhIHNsaW1lIG9uIGZsb29yIDZcIn19In0.nak_7FZ1LjWb3DQMURnLHOlJN2Tuy7aSOymS1jUYCnI]]
    payload, header = assert parse_jwt input

  it "fails on bad signature", ->
    input = [[eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjk4MjM0OTgyNzM0LCJleHAiOjkyODM3NDk4NzMyNCwiY29udGVudCI6ImhlbGxvIn0.ZUIvWj4cEd8mgLlz0BE--wtL5ybZoZT_fFPC0T04GQE]]
    out, err = parse_jwt input
    assert.nil, out
    assert.same "invalid signature", err


