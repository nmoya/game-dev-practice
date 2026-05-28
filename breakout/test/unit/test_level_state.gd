extends "res://addons/gut/test.gd"

const Helpers = preload("res://test/support/breakout_test_helpers.gd")

func _make_level_state() -> Variant:
	return Helpers.instantiate_script(self, Helpers.LEVEL_STATE_SCRIPT)

func test_level_state_counts_remaining_bricks() -> void:
	var level_state = _make_level_state()
	if not Helpers.assert_methods(self, level_state, ["set_total_bricks", "get_remaining_bricks"]):
		return
	level_state.set_total_bricks(12)
	assert_eq(level_state.get_remaining_bricks(), 12)

func test_registering_destroyed_bricks_can_complete_level() -> void:
	var level_state = _make_level_state()
	if not Helpers.assert_methods(self, level_state, ["set_total_bricks", "register_brick_destroyed", "get_remaining_bricks", "is_complete"]):
		return
	level_state.set_total_bricks(2)
	level_state.register_brick_destroyed()
	assert_eq(level_state.get_remaining_bricks(), 1)
	assert_false(level_state.is_complete())
	level_state.register_brick_destroyed()
	assert_eq(level_state.get_remaining_bricks(), 0)
	assert_true(level_state.is_complete())

func test_level_completed_signal_is_emitted_once() -> void:
	var level_state = _make_level_state()
	if not Helpers.assert_signals(self, level_state, ["completed"]):
		return
	if not Helpers.assert_methods(self, level_state, ["set_total_bricks", "register_brick_destroyed"]):
		return
	watch_signals(level_state)
	level_state.set_total_bricks(1)
	level_state.register_brick_destroyed()
	level_state.register_brick_destroyed()
	assert_signal_emit_count(level_state, "completed", 1)
