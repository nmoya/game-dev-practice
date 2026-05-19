extends Node2D

@export var left_paddle: Paddle
@export var right_paddle: Paddle
@export var ball: Ball
@export var divider_line: Line2D
@export var lower_wall: CollisionShape2D
@export var left_goal: Area2D
@export var right_goal: Area2D
@export var paddle_speed_ratio: float = 1.4

var left_score: int = 0
var right_score: int = 0

enum GameState {
	READY,
	PLAYING,
	POINT_SCORED
}

var state: GameState = GameState.READY
func _ready():
	update_layout(get_viewport_rect().size)
	set_state(GameState.READY)
	left_goal.body_entered.connect(on_left_goal_collision)
	right_goal.body_entered.connect(on_right_goal_collision)
	
func on_left_goal_collision(body: Ball):
	if state == GameState.PLAYING:
		print("Left goal")
	
func on_right_goal_collision(body: Ball):
	if state == GameState.PLAYING:
		print("Right goal")

func update_layout(screen_size: Vector2) -> void:
	var half_y = screen_size.y / 2
	var half_x = screen_size.x / 2
	var x_10pct = screen_size.x * 0.1
	left_paddle.position = Vector2(x_10pct, half_y)
	left_paddle.set_initial_x(x_10pct)
	left_paddle.set_paddle_speed(screen_size.y * paddle_speed_ratio)
	right_paddle.position = Vector2(screen_size.x - x_10pct, half_y)
	right_paddle.set_initial_x(screen_size.x - x_10pct)
	right_paddle.set_paddle_speed(screen_size.y * paddle_speed_ratio)
	divider_line.position = Vector2(half_x, 0)
	lower_wall.position.y = screen_size.y
	var goal_width = 10
	left_goal.position = Vector2(-goal_width, half_y)
	right_goal.position = Vector2(screen_size.x + goal_width, half_y)
	

func _process(delta) -> void:
	if state == GameState.READY and Input.is_action_just_pressed("start_round"):
		set_state(GameState.PLAYING)
	if Input.is_action_just_pressed("reset_round"):
		set_state(GameState.READY)

func set_state(new_state: GameState) -> void:
	state = new_state
	match state:
		GameState.READY:
			ball.reset_to(get_viewport_rect().size/2)
			ball.stop()
		GameState.PLAYING:
			ball.start()
		GameState.POINT_SCORED:
			ball.stop()
			await get_tree().create_timer(1.0).timeout
			set_state(GameState.READY)
