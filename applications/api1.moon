lapis = require "lapis"

import capture_errors_json, respond_to from require "lapis.application"

class Api1 extends lapis.Application
  @name: "api."
  @path: "/api/1"

  "/save-score": capture_errors_json respond_to {
    POST: =>
      import Scores from require "models"
      json: { success: true }
  }

