import decode_base64, encode_base64 from require "lapis.util.encoding"
import from_json from require "lapis.util"

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
  return nil, "missing data" unless str

  parts = [chunk for chunk in str\gmatch "[^%.]+"]
  raw_header, payload, signature = unpack parts

  header = decode_base64 normalize_b64 raw_header
  return nil, "invalid base64" unless header
  header = from_json header

  return nil, "header not JWT" unless header.typ == "JWT"
  return nil, "header not HS256" unless header.alg == "HS256"

  config = require("lapis.config").get!
  secret = assert config.jwt.secret, "missing jwt secret"

  expected_signature = encode_base64 hmac_sha256 secret, "#{raw_header}.#{payload}"
  unless expected_signature == normalize_b64 signature
    return nil, "invalid signature"

  payload = decode_base64 normalize_b64 payload
  from_json(payload), header, signature

{:parse_jwt, :add_padding, :hmac_sha256}
