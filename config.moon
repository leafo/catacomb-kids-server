config = require "lapis.config"


config {"development", "test"}, ->
  jwt {
    secret: "secret"
  }

config "development", ->
  code_cache "off"

  postgres {
    database: "catacombkids"
  }

config "test", ->
  code_cache "on"

  postgres {
    database: "catacombkids_test"
  }

config "production", ->
  port 10006
  code_cache "on"

  postgres {
    database: "catacombkids"
  }

  jwt require "secret.jwt"

