extends Node2D

@export var ball: Ball
@export var right_wall: CollisionShape2D
@export var paddle: Paddle
@export var pit: Area2D
@export var score_hud: ScoreHUD
@export var brick_wall: BrickWall

var state: GameState
var balls_left: int
var bricks: int = 0
enum GameState {
	NEW_GAME,
	READY_TO_LAUNCH,
	PLAYING,
	GAME_OVER
}

func _ready() -> void:
	pit.body_entered.connect(on_pit)
	set_game_state(GameState.NEW_GAME)
	
func ready_to_launch():
	update_layout(get_viewport_rect().size)
	
func new_game():
	set_balls_left(3)
	set_bricks_left(brick_wall.restart())
	set_game_state(GameState.READY_TO_LAUNCH)

func set_bricks_left(num: int):
	bricks = num
	score_hud.set_bricks_left(bricks)

func on_pit(body):
	set_balls_left(balls_left - 1)

func update_layout(viewport_size: Vector2) -> void:
	var center: Vector2 = viewport_size / 2
	var custom_y = viewport_size.y - viewport_size.y * 0.1 
	right_wall.position = Vector2(viewport_size.x, 0)
	paddle.position = Vector2(center.x, custom_y)
	pit.position = Vector2(center.x, viewport_size.y)
	var pit_shape := pit.get_node("CollisionShape2D").shape as RectangleShape2D
	pit_shape.size = Vector2(viewport_size.x, 50)
	ball.reset(Vector2(center.x, custom_y - 50))

func get_lives() -> int:
	return balls_left
	
func set_balls_left(new_value: int):
	balls_left = new_value
	score_hud.set_balls_left(balls_left)
	if balls_left == 0:
		set_game_state(GameState.GAME_OVER)
	else:
		set_game_state(GameState.READY_TO_LAUNCH)

func set_game_state(new_state: GameState):
	state = new_state
	match state:
		GameState.NEW_GAME:
			new_game()
		GameState.READY_TO_LAUNCH:
			ready_to_launch()
		GameState.PLAYING:
			pass
		GameState.GAME_OVER:
			await get_tree().create_timer(1.0).timeout
			set_game_state(GameState.NEW_GAME)
	

func launch():
	set_game_state(GameState.PLAYING)


func _on_ball_brick_destroyed() -> void:
	set_bricks_left(bricks - 1)
