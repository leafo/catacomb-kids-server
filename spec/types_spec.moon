
import use_test_env from require "lapis.spec"

import check, types from require "helpers.types"

describe "helpers.types", ->
  use_test_env!

  basic_types = {
    {"number", valid: 1234, invalid: "hello"}
    {"function", valid: (->), invalid: {}}
    {"string", valid: "234", invalid: 777}
    {"boolean", valid: true, invalid: 24323}

    {"table", valid: { hi: "world" }, invalid: "{}"}
    {"array", valid: { 1,2,3,4 }, invalid: {hi: "yeah"}, check_errors: false}
    {"array", valid: {}, check_errors: false}

  }

  for {type_name, :valid, :invalid, :check_errors} in *basic_types
    it "tests #{type_name}", ->
      t = types[type_name]

      assert.same {true}, {check valid, t}

      if invalid
        failure = {check invalid, t}
        if check_errors
          assert.same {nil, "got type #{type invalid}, expected #{type_name}"}, failure
        else
          assert.nil failure[1]

        failure = {check nil, t}
        if check_errors
          assert.same {nil, "got type nil, expected #{type_name}"}, failure
        else
          assert.nil failure[1]

      -- optional
      t = t\is_optional!
      assert.same {true}, {check valid, t}

      if invalid
        failure = {check invalid, t}
        if check_errors
          assert.same {nil, "got type #{type invalid}, expected #{type_name}"}, failure
        else
          assert.nil failure[1]

        assert.same {true}, {check nil, t}

  it "tests one_of", ->
    check = types.one_of {"a", "b"}
    check_opt = check\is_optional!

    assert.same nil, (check\check_value "c")
    assert.same true, (check\check_value "a")
    assert.same true, (check\check_value "b")
    assert.same nil, (check\check_value nil)

    assert.same nil, (check_opt\check_value "c")
    assert.same true, (check_opt\check_value "a")
    assert.same true, (check_opt\check_value "b")
    assert.same true, (check_opt\check_value nil)

    -- with sub type checkers
    check = types.one_of { "g", types.number, types.function }

    assert.same nil, (check\check_value "c")
    assert.same true, (check\check_value 2354)
    assert.same true, (check\check_value ->)
    assert.same true, (check\check_value "g")
    assert.same nil, (check\check_value nil)


