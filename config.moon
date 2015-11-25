config = require "lapis.config"


config {"development", "test"}, ->
  jwt {
    secret: "secret"
  }

config "development", ->
  postgres {
    database: "catacombkids"
  }

config "test", ->
  postgres {
    database: "catacombkids_test"
  }

config "production", ->
  postgres {
    database: "catacombkids"
  }

  jwt require "secret.jwt"

