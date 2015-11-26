
class BaseType
  @is_base_type: (val) =>
    cls = val and val.__class
    return false unless cls
    return true if BaseType == cls
    @is_base_type cls.__parent

  @__inherited: (cls) =>
    cls.__base.__call = cls.__call

  check_value: =>
    error "override me"

  check_optional: (value) =>
    value == nil and @opts and @opts.optional

  clone_opts: (merge) =>
    opts = if @opts
      {k,v for k,v in pairs @opts}
    else
      {}

    if merge
      for k, v in pairs merge
        opts[k] = v

    opts

  __call: (...) =>
    @check_value ...

-- basic type check
class Type extends BaseType
  new: (@t, @opts) =>

  is_optional: =>
    Type @t, @clone_opts optional: true

  check_value: (value) =>
    return true if @check_optional value

    got = type(value)
    if @t != got
      return nil, "got type `#{got}`, expected `#{@t}`"
    true

class ArrayType extends BaseType
  new: (@opts) =>

  is_optional: =>
    ArrayType @clone_opts optional: true

  check_value: (value) =>
    return true if @check_optional value
    return nil, "expecting table" unless type(value) == "table"

    k = 1
    for i,v in pairs value
      unless type(i) == "number"
        return nil, "non number key: #{i}"

      unless i == k
        return nil, "non array index, got `#{i}` but expected `#{k}`"

      k += 1

    true

class OneOf extends BaseType
  new: (@items, @opts) =>
    assert type(@items) == "table", "expected table for items in one_of"

  is_optional: =>
    OneOf @items, @clone_opts optional: true

  check_value: (value) =>
    return true if @check_optional value

    for item in *@items
      return true if item == value

      if item.check_value and BaseType\is_base_type item
        return true if item\check_value value

    err_str = table.concat ["`#{i}`" for i in *@items], ", "
    nil, "value `#{value}` did not match one of: #{err_str}"

class Shape extends BaseType
  new: (@shape, @opts) =>
    assert type(@shape) == "table", "expected table for shape"

  is_optional: =>
    Shape @shape, @clone_opts optional: true

  -- don't allow extra fields
  is_exact: =>
    Shape @shape, @clone_opts exact: true

  check_value: (value) =>
    return true if @check_optional value
    return nil, "expecting table" unless type(value) == "table"

    matches = true

    remaining_keys = if @opts and @opts.exact
      {key, true for key in pairs value}

    for shape_key, shape_val in pairs @shape
      item_value = value[shape_key]

      if remaining_keys
        remaining_keys[shape_key] = nil

      continue if shape_val == item_value

      if shape_val.check_value and BaseType\is_base_type shape_val
        res, err = shape_val\check_value item_value

        unless res
          return nil, "key `#{shape_key}`: #{err}"
      else
        return nil, "key `#{shape_key}` expected `#{shape_val}`"

    if remaining_keys
      if extra_key = next remaining_keys
        return nil, "has extra key: `#{extra_key}`"

    matches

class Pattern extends BaseType
  new: (@pattern, @opts) =>

  is_optional: =>
    Pattern @pattern, @clone_opts optional: true

  check_value: (value) =>
    return true if @check_optional value

    value = tostring value if @opts and @opts.coerce
    return nil, "expected string for value" unless type(value) == "string"

    if value\match @pattern
      true
    else
      nil, "doesn't match pattern `#{@pattern}`"

types = {
  string: Type "string"
  number: Type "number"
  function: Type "function"
  boolean: Type "boolean"
  userdata: Type "userdata"
  table: Type "table"
  array: ArrayType!

  -- compound
  integer: Pattern "^%d+$", coerce: true

  -- type constructors
  one_of: OneOf
  shape: Shape
  pattern: Pattern
}

check = (value, shape) ->
  assert shape.check_value, "missing check_value method from shape"
  shape\check_value value

{ :check, :types, :BaseType }
