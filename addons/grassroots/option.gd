## experimental optional type implemented in gdscript.
##
## there's no generics so this can't be strongly typed. might not be useful.
## [br]
## don't construct by itself, use methods [method some] and [method none] to
## create instances that ensure invariants etc.
## @experimental

const _Self = preload("res://addons/grassroots/option.gd")

var _has_value: bool
var _value: Variant
var _value_type: Variant.Type


## constructs a new [Opt] that contains [param vnt].
static func some(vnt: Variant) -> _Self:
	var op := new()
	op._has_value = true
	op._value = vnt
	op._value_type = typeof(vnt) as Variant.Type
	return op


## constructs a new empty [Opt].
static func none() -> _Self:
	var op := new()
	op._has_value = false
	op._value_type = TYPE_MAX
	return op


## returns [code]true[/code] if the [Opt] contains a value.
func has_value() -> bool:
	return _has_value


## returns [code]true[/code] if the [Opt] contains a value with the type [param type].
func has_value_of_type(type: Variant.Type) -> bool:
	return _value_type == type


## returns the value stored in the optional. assertion fails if [Opt] is empty.
func get_value() -> Variant:
	assert(_has_value, "optional is none")
	return _value


## if the [Opt] has a value, calls [param some_cb] with the value as a parameter
## and returns the result. otherwise, calls [param none_cb] and returns its result.
## [param some_cb] must take one argument.
func match_var(some_cb: Callable, none_cb: Callable) -> Variant:
	if _has_value:
		assert(some_cb.get_argument_count() == 1)
		return some_cb.call(_value)
	return none_cb.call()


## if the [Opt] has a value, calls [param some_cb] with the value as a parameter.
## otherwise, calls [param none_cb]. [param some_cb] must take one argument.
func match_void(some_cb: Callable, none_cb: Callable) -> void:
	if _has_value:
		assert(some_cb.get_argument_count() == 1)
		some_cb.call(_value)
		return
	none_cb.call()


class Tests extends Testing:

	const Opt = preload("res://addons/grassroots/option.gd")

	static func test_case_none() -> Result:
		var op := Opt.none()
		if not assert_false(op.has_value()):
			return FAIL
		return PASS


	static func test_case_some() -> Result:
		var op := Opt.some(10)
		if not assert_true(op.has_value()):
			return FAIL
		if not assert_true(op.has_value_of_type(TYPE_INT)):
			return FAIL
		if not assert_eq(op.get_value(), 10):
			return FAIL
		return PASS


	static func test_case_match() -> Result:
		var op := Opt.some(5)
		var result := 0
		result = op.match_var(
			func(a: int) -> int:
				if a == 5: return 1
				else: return 2,
			func() -> int:
				return 3
		)
		if not assert_eq(result, 1):
			return FAIL
		var result2 := [0]
		op = _Self.none()
		op.match_void(
			func(a: int) -> void:
				if a == 5: result2[0] = 1
				else: result2[0] = 2,
			func() -> void:
				result2[0] = 3
		)
		if not assert_eq(result2[0], 3):
			return FAIL
		return PASS
