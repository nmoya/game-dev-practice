extends "res://addons/gut/test.gd"

const Helpers := preload("res://test/support/breakout_test_helpers.gd")

func _make_main_scene() -> Variant:
	var scene = Helpers.load_required(self, Helpers.MAIN_SCENE)
	if scene == null:
		return null
	var instance = scene.instantiate()
	add_child_autofree(instance)
	return instance

func test_main_scene_contains_required_gameplay_nodes() -> void:
	var game = _make_main_scene()
	if game == null:
		return
	assert_not_null(game.get_node_or_null("Ball"), "Main scene should contain Ball")
	assert_not_null(game.get_node_or_null("Paddle"), "Main scene should contain Paddle")
	assert_not_null(game.get_node_or_null("Bricks"), "Main scene should contain Bricks")
	assert_not_null(game.get_node_or_null("HUD"), "Main scene should contain HUD")

func test_new_game_builds_level_and_waits_for_launch() -> void:
	var game = _make_main_scene()
	if game == null or not Helpers.assert_methods(self, game, ["start_new_game", "get_remaining_bricks", "is_ready", "get_score", "get_lives"]):
		return
	game.start_new_game()
	assert_true(game.is_ready())
	assert_gt(game.get_remaining_bricks(), 0)
	assert_eq(game.get_score(), 0)
	assert_gt(game.get_lives(), 0)

func test_launch_starts_active_play() -> void:
	var game = _make_main_scene()
	if game == null or not Helpers.assert_methods(self, game, ["start_new_game", "launch_ball", "is_playing"]):
		return
	game.start_new_game()
	game.launch_ball()
	assert_true(game.is_playing())

func test_losing_ball_decrements_lives_and_resets_ball() -> void:
	var game = _make_main_scene()
	if game == null or not Helpers.assert_methods(self, game, ["start_new_game", "launch_ball", "handle_ball_lost", "get_lives", "is_ready"]):
		return
	game.start_new_game()
	var starting_lives: int = game.get_lives()
	game.launch_ball()
	game.handle_ball_lost()
	assert_eq(game.get_lives(), starting_lives - 1)
	assert_true(game.is_ready())

func test_clearing_all_bricks_completes_level() -> void:
	var game = _make_main_scene()
	if game == null or not Helpers.assert_methods(self, game, ["start_new_game", "clear_all_bricks", "is_level_complete"]):
		return
	game.start_new_game()
	game.clear_all_bricks()
	assert_true(game.is_level_complete())
