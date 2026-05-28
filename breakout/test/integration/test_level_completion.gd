extends "res://addons/gut/test.gd"

const Helpers := preload("res://test/support/breakout_test_helpers.gd")

func test_level_complete_signal_is_emitted_when_last_brick_is_destroyed() -> void:
	var game_scene = Helpers.load_required(self, Helpers.MAIN_SCENE)
	if game_scene == null:
		return
	var game = game_scene.instantiate()
	add_child_autofree(game)
	if not Helpers.assert_signals(self, game, ["level_complete"]):
		return
	if not Helpers.assert_methods(self, game, ["start_new_game", "clear_all_bricks"]):
		return
	watch_signals(game)
	game.start_new_game()
	game.clear_all_bricks()
	assert_signal_emitted(game, "level_complete")
