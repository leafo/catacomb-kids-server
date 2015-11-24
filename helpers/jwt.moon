import decode_base64, encode_base64 from require "lapis.util.encoding"
import from_json from require "lapis.util"

SECRET = "secret"

crypto = require "crypto"

hmac_sha256 = (secret, str) ->
  crypto.hmac.digest "sha256", str, secret, true

add_padding = (str) ->
  need = #str % 4
  if need > 0
    str .. "="\rep 4 - need
  else
    str

normalize_b64 = (str) ->
  add_padding str\gsub "[%-_]", {
    "-": "+"
    "_": "/"
  }

parse_jwt = (str) ->
  parts = [chunk for chunk in str\gmatch "[^%.]+"]
  header, payload, signature = unpack parts

  expected_signature = encode_base64 hmac_sha256 SECRET, "#{header}.#{payload}"

  unless expected_signature == normalize_b64 signature
    return nil, "invalid signature"

  header = decode_base64 normalize_b64 header
  header = from_json header

  return nil, "header not JWT" unless header.typ == "JWT"
  return nil, "header not HS256" unless header.alg == "HS256"

  payload = decode_base64 normalize_b64 payload
  from_json payload

{:parse_jwt, :add_padding}
