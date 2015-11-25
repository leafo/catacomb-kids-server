db = require "lapis.db"
import Model from require "lapis.db.model"

import to_json from require "lapis.util"

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

  @create: (opts) =>
    unless type(opts.raw_data) == "string"
      opts.raw_data = to_json assert opts.raw_data, "missing raw data"

    Model.create @, opts

