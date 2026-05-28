extends "res://addons/gut/test.gd"

const Helpers = preload("res://test/support/breakout_test_helpers.gd")

func _make_paddle() -> Variant:
	return Helpers.instantiate_script(self, Helpers.PADDLE_SCRIPT)

func test_paddle_moves_right_and_left_frame_independently() -> void:
	var paddle = _make_paddle()
	if not Helpers.assert_methods(self, paddle, ["move"]):
		return
	paddle.position = Vector2(320.0, 440.0)
	var bounds := Rect2(Vector2.ZERO, Vector2(640.0, 480.0))
	paddle.move(1.0, 0.5, bounds)
	var right_position: float = paddle.position.x
	paddle.position = Vector2(320.0, 440.0)
	paddle.move(1.0, 0.25, bounds)
	paddle.move(1.0, 0.25, bounds)
	assert_almost_eq(paddle.position.x, right_position, 0.01)
	paddle.move(-1.0, 0.5, bounds)
	assert_lt(paddle.position.x, right_position)

func test_paddle_is_clamped_inside_playfield() -> void:
	var paddle = _make_paddle()
	if not Helpers.assert_methods(self, paddle, ["move", "get_bounds"]):
		return
	var bounds := Rect2(Vector2.ZERO, Vector2(640.0, 480.0))
	paddle.position = Vector2(4.0, 440.0)
	paddle.move(-1.0, 10.0, bounds)
	assert_gte(paddle.get_bounds().position.x, bounds.position.x)
	paddle.position = Vector2(636.0, 440.0)
	paddle.move(1.0, 10.0, bounds)
	assert_lte(paddle.get_bounds().end.x, bounds.end.x)

func test_paddle_bounce_direction_depends_on_hit_position() -> void:
	var paddle = _make_paddle()
	if not Helpers.assert_methods(self, paddle, ["bounce_direction_for_hit"]):
		return
	paddle.position = Vector2(320.0, 440.0)
	var left_direction: Vector2 = paddle.bounce_direction_for_hit(Vector2(270.0, 440.0))
	var center_direction: Vector2 = paddle.bounce_direction_for_hit(Vector2(320.0, 440.0))
	var right_direction: Vector2 = paddle.bounce_direction_for_hit(Vector2(370.0, 440.0))
	assert_lt(left_direction.x, center_direction.x)
	assert_lt(center_direction.x, right_direction.x)
	assert_lt(left_direction.y, 0.0)
	assert_lt(center_direction.y, 0.0)
	assert_lt(right_direction.y, 0.0)

func test_paddle_can_launch_attached_ball() -> void:
	var paddle = _make_paddle()
	var ball = Helpers.instantiate_script(self, Helpers.BALL_SCRIPT)
	if not Helpers.assert_methods(self, paddle, ["attach_ball", "launch_attached_ball"]):
		return
	if not Helpers.assert_methods(self, ball, ["is_waiting_for_launch", "get_velocity"]):
		return
	paddle.attach_ball(ball)
	paddle.launch_attached_ball()
	assert_false(ball.is_waiting_for_launch())
	assert_gt(ball.get_velocity().length(), 0.0)
