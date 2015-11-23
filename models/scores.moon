db = require "lapis.db"
import Model from require "lapis.db.model"

import to_json from require "lapis.util"

class Scores extends Model
  @timestamp: true

  @create: (opts) =>
    opts.raw_data = to_json assert opts.raw_data, "missing raw data"
    Model.create @, opts

