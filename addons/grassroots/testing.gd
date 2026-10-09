@abstract class_name Testing

## base abstract class for unit test sets.
##
## the imagined workflow:
## [br]	1. inherit from this class
## [br]	2. write tests as static methods with their names beginning with
## [code]test_case_[/code] and which return a [enum Result] value
## [br]	3. call [method run_tests], passing the inherited class as an argument.[br]
## test cases must return a [enum Result] value. this is used to see
## whether the test case passed or failed. [br]
## assertion methods can be used inside the test cases. they also return
## [enum Result] values. one can have multiple assertions in their testing like so:
## [codeblock]static func test_case_a() -> Result:
##     if not assert_eq(1, 2): return FAIL
##     if not assert_true(true): return FAIL
##     return PASS

## values which must be returned from test cases.
enum Result {
	FAIL, ## the test case failed.
	PASS, ## the test case passed.
}

# quick access to [enum Result] values.
const FAIL := Result.FAIL
const PASS := Result.PASS

## test case methods must be static and their names start with [code]test_case_[/code].
const TEST_CASE_START := "test_case_"

static var _current_case: String
static var _current_failure: String


## asserts that [param a] is truthy.
static func assert_true(a: Variant, comment: String = "") -> Result:
	if not a:
		push_error("case %s failed: a is false" % _current_case)
		_current_failure = comment if comment else "%s is false" % [a]
		return FAIL
	return PASS


## asserts that [param a] is falsy.
static func assert_false(a: Variant, comment: String = "") -> Result:
	if a:
		push_error("case %s failed: a is true" % _current_case)
		_current_failure = comment if comment else "%s is true" % [a]
		return FAIL
	return PASS


## asserts that [param a] and [param b] are equal.
static func assert_eq(a: Variant, b: Variant, comment: String = "") -> Result:
	if a != b:
		push_error("case %s failed: a != b" % _current_case)
		_current_failure = comment if comment else "%s != %s" % [a, b]
		return FAIL
	return PASS


## asserts that [param a] and [param b] are not equal.
static func assert_neq(a: Variant, b: Variant, comment: String = "") -> Result:
	if a == b:
		push_error("case %s failed: a == b" % _current_case)
		_current_failure = comment if comment else "%s == %s" % [a, b]
		return FAIL
	return PASS


## runs all tests. test cases must be static functions defined on the class
## whose names begin with [code]test_case_[/code] and which have no arguments.
## provide test case class as [param script].
static func run_tests(script: GDScript) -> void:
	if script.get_base_script() != Testing:
		push_error("attempted running tests on script that doesn't inherit from Testing.")
		push_error("please provide script that inherits the class Testing.")
		push_error("see Testing documentation.")
		return
	var sname := script.get_global_name()
	if not sname:
		sname = script.resource_path
	if not sname:
		sname = str(script)
	print_rich("running tests on %s." % sname)
	#print(script.get_script_method_list().map(func(m: Dictionary) -> String: return m.name))
	var ob: RefCounted = script.new()
	var cases: Array[Dictionary] = (script.get_script_method_list()
		.filter(func(m: Dictionary) -> bool:
			return ((m.name as String).begins_with(TEST_CASE_START)
				#and ((m.flags as MethodFlags) & METHOD_FLAG_STATIC) != 0
				)))
	for c in cases:
		if ((c.flags as MethodFlags) & METHOD_FLAG_STATIC) == 0:
			push_error("test case method %s is not static." % c.name)
			return
	print("found %s test cases." % cases.size())
	if cases.size() == 0:
		print_rich("[color=red]no test cases found.")
	var passing := 0
	var failing := []
	for tc in cases:
		_current_case = tc.name.trim_prefix(TEST_CASE_START)
		var result: Result = ob.call(tc.name)
		match result:
			Result.PASS:
				passing += 1
			Result.FAIL:
				failing.append([tc.name, _current_failure])
	_current_case = ""
	_current_failure = ""
	if cases.size() == passing:
		print_rich("[color=green]all tests passed.")
	else:
		print_rich("[color=red]%s tests failed." % failing.size())
		for f in failing:
			print_rich("\t[color=red]%s (%s)" % [f[0], f[1]])
