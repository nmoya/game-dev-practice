extends "res://addons/gut/test.gd"

const Helpers = preload("res://test/support/breakout_test_helpers.gd")

func test_paddle_collision_sends_ball_upward_with_paddle_angle() -> void:
	var ball = Helpers.instantiate_script(self, Helpers.BALL_SCRIPT)
	var paddle = Helpers.instantiate_script(self, Helpers.PADDLE_SCRIPT)
	if not Helpers.assert_methods(self, ball, ["set_velocity", "get_velocity", "apply_paddle_bounce"]):
		return
	if not Helpers.assert_methods(self, paddle, ["bounce_direction_for_hit"]):
		return
	paddle.position = Vector2(320.0, 440.0)
	ball.set_velocity(Vector2(0.0, 300.0))
	ball.apply_paddle_bounce(paddle, Vector2(370.0, 440.0))
	assert_lt(ball.get_velocity().y, 0.0)
	assert_gt(ball.get_velocity().x, 0.0)

func test_brick_collision_damages_brick_awards_score_and_bounces_ball() -> void:
	var ball = Helpers.instantiate_script(self, Helpers.BALL_SCRIPT)
	var brick = Helpers.instantiate_script(self, Helpers.BRICK_SCRIPT)
	var score = Helpers.instantiate_script(self, Helpers.SCORE_SCRIPT)
	if not Helpers.assert_methods(self, ball, ["set_velocity", "get_velocity", "apply_brick_bounce"]):
		return
	if not Helpers.assert_methods(self, brick, ["configure", "hit", "is_destroyed", "get_score_value"]):
		return
	if not Helpers.assert_methods(self, score, ["add_points", "get_value"]):
		return
	brick.configure(1, 100)
	ball.set_velocity(Vector2(0.0, -300.0))
	brick.hit()
	if brick.is_destroyed():
		score.add_points(brick.get_score_value())
	ball.apply_brick_bounce(Vector2.DOWN)
	assert_true(brick.is_destroyed())
	assert_eq(score.get_value(), 100)
	assert_gt(ball.get_velocity().y, 0.0)
