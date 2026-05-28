extends RefCounted

const BALL_SCRIPT := "res://src/ball.gd"
const BRICK_SCRIPT := "res://src/brick.gd"
const GAME_STATE_SCRIPT := "res://src/breakout.gd"
const LEVEL_STATE_SCRIPT := "res://src/level_state.gd"
const PADDLE_SCRIPT := "res://src/paddle.gd"
const SCORE_SCRIPT := "res://src/score.gd"
const MAIN_SCENE := "res://scenes/main.tscn"

static func load_required(test, path: String) -> Variant:
	var resource := load(path)
	test.assert_not_null(resource, "%s should exist" % path)
	return resource

static func instantiate_script(test, path: String) -> Variant:
	var script = load_required(test, path)
	if script == null:
		return null
	var instance = script.new()
	test.assert_not_null(instance, "%s should instantiate" % path)
	return instance

static func assert_methods(test, instance: Object, methods: Array[String]) -> bool:
	if instance == null:
		return false
	var all_present := true
	for method in methods:
		var has_method := instance.has_method(method)
		test.assert_true(has_method, "%s should implement %s()" % [instance.get_script().resource_path, method])
		all_present = all_present and has_method
	return all_present

static func assert_signals(test, instance: Object, signals: Array[String]) -> bool:
	if instance == null:
		return false
	var all_present := true
	for signal_name in signals:
		var has_named_signal := instance.has_signal(signal_name)
		test.assert_true(has_named_signal, "%s should define signal %s" % [instance.get_script().resource_path, signal_name])
		all_present = all_present and has_named_signal
	return all_present
