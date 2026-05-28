extends "res://addons/gut/test.gd"

const Helpers = preload("res://test/support/breakout_test_helpers.gd")

func _make_brick() -> Variant:
	return Helpers.instantiate_script(self, Helpers.BRICK_SCRIPT)

func test_brick_tracks_hit_points_and_score_value() -> void:
	var brick = _make_brick()
	if not Helpers.assert_methods(self, brick, ["configure", "get_hit_points", "get_score_value"]):
		return
	brick.configure(2, 150)
	assert_eq(brick.get_hit_points(), 2)
	assert_eq(brick.get_score_value(), 150)

func test_hit_reduces_hit_points() -> void:
	var brick = _make_brick()
	if not Helpers.assert_methods(self, brick, ["configure", "hit", "get_hit_points", "is_destroyed"]):
		return
	brick.configure(2, 100)
	brick.hit()
	assert_eq(brick.get_hit_points(), 1)
	assert_false(brick.is_destroyed())

func test_final_hit_destroys_brick_and_disables_collision() -> void:
	var brick = _make_brick()
	if not Helpers.assert_methods(self, brick, ["configure", "hit", "is_destroyed", "is_collision_enabled"]):
		return
	brick.configure(1, 100)
	brick.hit()
	assert_true(brick.is_destroyed())
	assert_false(brick.is_collision_enabled())

func test_brick_emits_damaged_and_destroyed_signals() -> void:
	var brick = _make_brick()
	if not Helpers.assert_signals(self, brick, ["damaged", "destroyed"]):
		return
	if not Helpers.assert_methods(self, brick, ["configure", "hit"]):
		return
	watch_signals(brick)
	brick.configure(2, 100)
	brick.hit()
	assert_signal_emitted(brick, "damaged")
	brick.hit()
	assert_signal_emitted(brick, "destroyed")
