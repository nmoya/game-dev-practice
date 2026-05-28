extends "res://addons/gut/test.gd"

const Helpers = preload("res://test/support/breakout_test_helpers.gd")

func _make_score() -> Variant:
	return Helpers.instantiate_script(self, Helpers.SCORE_SCRIPT)

func test_score_starts_at_zero() -> void:
	var score = _make_score()
	if not Helpers.assert_methods(self, score, ["get_value"]):
		return
	assert_eq(score.get_value(), 0)

func test_add_points_increases_score() -> void:
	var score = _make_score()
	if not Helpers.assert_methods(self, score, ["add_points", "get_value"]):
		return
	score.add_points(100)
	score.add_points(50)
	assert_eq(score.get_value(), 150)

func test_reset_clears_score() -> void:
	var score = _make_score()
	if not Helpers.assert_methods(self, score, ["add_points", "reset", "get_value"]):
		return
	score.add_points(200)
	score.reset()
	assert_eq(score.get_value(), 0)

func test_score_changed_signal_is_emitted() -> void:
	var score = _make_score()
	if not Helpers.assert_signals(self, score, ["changed"]):
		return
	if not Helpers.assert_methods(self, score, ["add_points"]):
		return
	watch_signals(score)
	score.add_points(100)
	assert_signal_emitted(score, "changed")
