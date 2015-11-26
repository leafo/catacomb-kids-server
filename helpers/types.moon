
class BaseType
  @is_base_type: (val) =>
    cls = val and val.__class
    return false unless cls
    return true if BaseType == cls
    @is_base_type cls.__parent

  check_optional: (value) =>
    value == nil and @opts and @opts.optional

-- basic type check
class Type extends BaseType
  new: (@t, @opts) =>

  is_optional: =>
    Type @t, optional: true

  check_value: (value) =>
    return true if @check_optional value

    got = type(value)
    if @t != got
      return nil, "got type #{got}, expected #{@t}"
    true

class ArrayType extends BaseType
  new: (@opts) =>

  is_optional: =>
    ArrayType optional: true

  check_value: (value) =>
    return true if @check_optional value
    return nil, "expecting table" unless type(value) == "table"

    k = 1
    for i,v in pairs value
      unless type(i) == "number"
        return nil, "non number key: #{i}"

      unless i == k
        return nil, "non array index, got #{i} but expected #{k}"

      k += 1

    true

class OneOf extends BaseType
  new: (@items, @opts) =>
    assert type(@items) == "table", "expected table for items in one_of"

  is_optional: =>
    OneOf @items, optional: true

  check_value: (value) =>
    return true if @check_optional value

    for item in *@items
      return true if item == value

      if item.check_value and BaseType\is_base_type item
        return true if item\check_value value

    nil, "value did not match one of"

types = {
  string: Type "string"
  number: Type "number"
  function: Type "function"
  boolean: Type "boolean"
  userdata: Type "userdata"
  table: Type "table"
  array: ArrayType!
  one_of: OneOf
}

check = (value, shape) ->
  assert shape.check_value, "missing check_value method from shape"
  shape\check_value value

{ :check, :types, :BaseType }
