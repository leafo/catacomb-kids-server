db = require "lapis.db"
import Model, enum from require "lapis.db.model"

import to_json from require "lapis.util"

import types from require "helpers.types"

-- Generated schema dump: (do not edit)
--
-- CREATE TABLE scores (
--   id integer NOT NULL,
--   raw_data jsonb NOT NULL,
--   ip character varying(255) NOT NULL,
--   created_at timestamp without time zone NOT NULL,
--   updated_at timestamp without time zone NOT NULL
-- );
-- ALTER TABLE ONLY scores
--   ADD CONSTRAINT scores_pkey PRIMARY KEY (id);
--
class Scores extends Model
  @timestamp: true

  @environments: enum {
    default: 1
    test: 2
  }

  @raw_data_type: types.shape {
    version_major: types.integer
    version_minor: types.integer
    version_patch: types.integer

    version_suffix: types.string\is_optional!
    player_name: types.string

    base_class: types.one_of {
      "bully"
      "convert"
      "poet"
      "merchant"
      "tinkerer"
      "wanderer"
    }

    floor_reached: types.integer
    play_time: types.integer
    total_kills: types.integer
    total_gold: types.integer
    final_score: types.integer
    daily_run_day: types.string\is_optional!
    about_kid: types.table
  }

  @create: (opts) =>
    unless type(opts.raw_data) == "string"
      opts.raw_data = to_json assert opts.raw_data, "missing raw data"

    opts.environment = @environments\for_db opts.environment or "default"

    Model.create @, opts


  parse_data: =>
    import from_json from require "lapis.util"
    from_json @raw_data
