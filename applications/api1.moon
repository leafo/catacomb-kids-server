lapis = require "lapis"

import capture_errors, respond_to, assert_error from require "lapis.application"
import assert_valid from require "lapis.validate"
import parse_jwt from require "helpers.jwt"
import from_json from require "lapis.util"

capture_errors_json = (fn) ->
  capture_errors fn, => {
    json: { errors: @errors }, status: 403
  }

class Api1 extends lapis.Application
  @name: "api."
  @path: "/api/1"

  "/list": capture_errors_json respond_to {
    GET: =>
      import Scores from require "models"

      assert_valid @params, {
        {"page", optional: true, is_integer: true}
      }

      pager = Scores\paginated "
        where environment = ? order by id desc
      ", Scores.environments.default
      scores = pager\get_page @params.page or 1

      json: {
        scores: [score\parse_data! for score in *scores]
      }
  }

  "/save-score": capture_errors_json respond_to {
    GET: =>
      text: "", layout: false

    POST: =>
      import Scores from require "models"
      ngx.req.read_body!
      data = assert ngx.req.get_body_data!

      assert_valid @params, {
        {"environment", optional: true, one_of: {"test"}}
      }

      payload, _, signature = assert_error parse_jwt data
      content = assert_error payload.content, "missing content"

      local parsed_content
      pcall -> parsed_content = from_json content

      success, err = parsed_content, "content is not json"
      if success
        success, err =  Scores.raw_data_type parsed_content

      unless success
        return json: { errors: {err} }, status: 400

      Scores\create {
        environment: @params.environment
        hash: signature
        raw_data: content
        ip: ngx.var.remote_addr
      }

      json: { success: true }
  }
