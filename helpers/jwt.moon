import decode_base64 from require "lapis.util.encoding"
import from_json from require "lapis.util"

parse_jwt = (str) ->
  parts = [chunk for chunk in str\gmatch "[^%.]+"]
  header, payload, signature = unpack parts
  payload = decode_base64 payload
  payload = from_json payload
  require("moon").p payload

{:parse_jwt}
