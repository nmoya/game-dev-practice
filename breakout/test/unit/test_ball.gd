extends "res://addons/gut/test.gd"

const Helpers := preload("res://test/support/breakout_test_helpers.gd")

func _make_ball() -> Variant:
	return Helpers.instantiate_script(self, Helpers.BALL_SCRIPT)

func test_ball_starts_waiting_for_launch() -> void:
	var ball = _make_ball()
	if not Helpers.assert_methods(self, ball, ["is_waiting_for_launch", "get_velocity"]):
		return
	assert_true(ball.is_waiting_for_launch())
	assert_eq(ball.get_velocity(), Vector2.ZERO)

func test_launch_sets_non_zero_velocity_and_marks_ball_active() -> void:
	var ball = _make_ball()
	if not Helpers.assert_methods(self, ball, ["launch", "is_waiting_for_launch", "get_velocity"]):
		return
	ball.launch(Vector2.UP)
	assert_false(ball.is_waiting_for_launch())
	assert_gt(ball.get_velocity().length(), 0.0)
	assert_lt(ball.get_velocity().y, 0.0)

func test_wall_bounce_with_horizontal_normal_reverses_horizontal_velocity_without_changing_speed() -> void:
	var ball = _make_ball()
	if not Helpers.assert_methods(self, ball, ["set_velocity", "get_velocity", "wall_bounce"]):
		return
	ball.set_velocity(Vector2(120.0, -80.0))
	var speed_before = ball.get_velocity().length()
	ball.wall_bounce(Vector2.LEFT)
	assert_lt(ball.get_velocity().x, 0.0)
	assert_almost_eq(ball.get_velocity().length(), speed_before, 0.01)

func test_wall_bounce_with_vertical_normal_reverses_vertical_velocity_without_changing_speed() -> void:
	var ball = _make_ball()
	if not Helpers.assert_methods(self, ball, ["set_velocity", "get_velocity", "wall_bounce"]):
		return
	ball.set_velocity(Vector2(80.0, 120.0))
	var speed_before = ball.get_velocity().length()
	ball.wall_bounce(Vector2.UP)
	assert_lt(ball.get_velocity().y, 0.0)
	assert_almost_eq(ball.get_velocity().length(), speed_before, 0.01)

func test_reset_places_ball_at_spawn_and_waits_for_launch() -> void:
	var ball = _make_ball()
	if not Helpers.assert_methods(self, ball, ["reset", "is_waiting_for_launch", "get_velocity"]):
		return
	var spawn := Vector2(320.0, 420.0)
	ball.reset(spawn)
	assert_eq(ball.position, spawn)
	assert_true(ball.is_waiting_for_launch())
	assert_eq(ball.get_velocity(), Vector2.ZERO)

func test_ball_reports_lost_when_below_playfield() -> void:
	var ball = _make_ball()
	if not Helpers.assert_methods(self, ball, ["is_lost"]):
		return
	ball.position = Vector2(320.0, 150001.0)
	assert_true(ball.is_lost(Rect2(Vector2.ZERO, Vector2(1920.0, 1080.0))))

func test_ball_has_lost_signal() -> void:
	var ball = _make_ball()
	Helpers.assert_signals(self, ball, ["lost"])
