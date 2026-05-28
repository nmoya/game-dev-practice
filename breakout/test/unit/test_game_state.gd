extends "res://addons/gut/test.gd"

const Helpers = preload("res://test/support/breakout_test_helpers.gd")

func _make_game_state() -> Variant:
	return Helpers.instantiate_script(self, Helpers.GAME_STATE_SCRIPT)

func test_game_state_starts_ready_with_initial_lives() -> void:
	var game_state = _make_game_state()
	if not Helpers.assert_methods(self, game_state, ["start_new_game", "get_lives", "is_ready", "is_playing"]):
		return
	game_state.start_new_game(3)
	assert_eq(game_state.get_lives(), 3)
	assert_true(game_state.is_ready())
	assert_false(game_state.is_playing())

func test_launch_changes_state_to_playing() -> void:
	var game_state = _make_game_state()
	if not Helpers.assert_methods(self, game_state, ["start_new_game", "launch", "is_playing"]):
		return
	game_state.start_new_game(3)
	game_state.launch()
	assert_true(game_state.is_playing())

func test_losing_ball_decrements_lives_and_returns_to_ready() -> void:
	var game_state = _make_game_state()
	if not Helpers.assert_methods(self, game_state, ["start_new_game", "launch", "lose_life", "get_lives", "is_ready", "is_game_over"]):
		return
	game_state.start_new_game(3)
	game_state.launch()
	game_state.lose_life()
	assert_eq(game_state.get_lives(), 2)
	assert_true(game_state.is_ready())
	assert_false(game_state.is_game_over())

func test_losing_final_life_triggers_game_over_signal() -> void:
	var game_state = _make_game_state()
	if not Helpers.assert_signals(self, game_state, ["game_over_signal"]):
		return
	if not Helpers.assert_methods(self, game_state, ["start_new_game", "lose_life", "is_game_over"]):
		return
	watch_signals(game_state)
	game_state.start_new_game(1)
	game_state.lose_life()
	assert_true(game_state.is_game_over())
	assert_signal_emitted(game_state, "game_over_signal")

func test_restart_resets_terminal_states() -> void:
	var game_state = _make_game_state()
	if not Helpers.assert_methods(self, game_state, ["start_new_game", "lose_life", "restart", "get_lives", "is_ready", "is_game_over"]):
		return
	game_state.start_new_game(1)
	game_state.lose_life()
	game_state.restart()
	assert_eq(game_state.get_lives(), 3)
	assert_true(game_state.is_ready())
	assert_false(game_state.is_game_over())
