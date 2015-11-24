lapis = require "lapis"

class extends lapis.Application
  @include "applications.api1"

  "/": =>
    "Welcome to catacomb kids server"
