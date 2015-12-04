
db = require "lapis.db"
schema = require "lapis.db.schema"

import add_column, create_index, drop_index, drop_column, create_table from schema

{
  :serial, :boolean, :varchar, :integer, :text, :foreign_key, :double, :time,
  :numeric, :enum
} = schema.types

{
  [1448301320]: ->
    create_table "scores", {
      {"id", serial}
      {"raw_data", "jsonb not null"}
      {"ip", varchar}

      {"created_at", time}
      {"updated_at", time}

      {"environment", enum}
      {"hash", varchar}

      "PRIMARY KEY (id)"
    }

    create_index "scores", "environment", "hash", unique: true
    create_index "scores", "environment", "created_at"
    create_index "scores", "environment", "id"
}

