
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

      {"created_at", time}
      {"updated_at", time}

      "PRIMARY KEY (id)"
    }
}

