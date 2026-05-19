class_name Paddle
extends CharacterBody2D
@onready var paddle: CollisionShape2D = $CollisionShape2D
@export_enum("PlayerOne", "PlayerTwo") var player: String = ""
var initial_position_x = 0
var speed = 0

func _ready():
	if player.is_empty():
		push_error("%s is missing a player value. Set player to PlayerOne or PlayerTwo." % name)
		set_physics_process(false)
		return
		
func set_initial_x(value: float):
	initial_position_x = value

func set_paddle_speed(value: float):
	speed = value

func get_direction() -> float:
	match player:
		"PlayerOne": 
			return Input.get_axis("player1_up", "player1_down")
		"PlayerTwo":
			return Input.get_axis("player2_up", "player2_down")
		_:
			push_error("Invalid player value")
			return 0.0

func _physics_process(delta: float) -> void:
	var direction := get_direction()
	var half_height := get_paddle_size().y / 2.0
	var screen_height := get_viewport_rect().size.y
	velocity = Vector2(0.0, direction * speed)
	move_and_slide()
	position.y = clamp(position.y, half_height, screen_height - half_height)
	position.x = initial_position_x

func get_paddle_size() -> Vector2:
	var rect := paddle.shape as RectangleShape2D
	return rect.size * paddle.scale.abs()
