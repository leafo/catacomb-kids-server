lapis = require "lapis"

class extends lapis.Application
  @include "applications.api1"

  [home: "/"]: =>
    "Welcome to catacomb kids server"
