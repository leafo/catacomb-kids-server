lapis = require "lapis"

class extends lapis.Application
  @include "applications.api1"
  handle_404: => status: 404, "nothing here"

