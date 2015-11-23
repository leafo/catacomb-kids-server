config = require "lapis.config"

config "development", ->
  postgres {
    database: "catacombkids"
  }

config "test", ->
  postgres {
    database: "catacombkids_test"
  }
