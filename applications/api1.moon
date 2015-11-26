lapis = require "lapis"

import capture_errors_json, respond_to, assert_error from require "lapis.application"
import parse_jwt from require "helpers.jwt"
import from_json from require "lapis.util"

class Api1 extends lapis.Application
  @name: "api."
  @path: "/api/1"

  "/save-score": capture_errors_json respond_to {
    GET: =>
      text: "", layout: false

    POST: =>
      import Scores from require "models"
      ngx.req.read_body!
      data = assert ngx.req.get_body_data!

      payload = assert_error parse_jwt data
      content = assert_error payload.content, "missing content"

      local parsed_content
      pcall -> parsed_content = from_json content
      assert_error parsed_content, "content is not json"

      assert_error Scores.raw_data_type parsed_content

      Scores\create {
        raw_data: content
        ip: ngx.var.remote_addr
      }

      json: { success: true }
  }
