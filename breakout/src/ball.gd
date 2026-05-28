class_name Ball
extends CharacterBody2D

signal lost
signal brick_destroyed
@export var max_bounce_angle: int = 60
@export var current_speed: int = 1000

func speed():
	return current_speed

var _waiting_for_launch: bool = true

func reset(new_position: Vector2):
	velocity = Vector2.ZERO
	position = new_position
	_waiting_for_launch = true

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if not collision:
		return
	if collision.get_collider().is_in_group("paddles"):
		var paddle = collision.get_collider()
		var paddle_size = paddle.get_paddle_size()
		var hit_offset: float = clamp(
			(position.x - paddle.position.x) / (paddle_size.x / 2.0),
			-1.0,
			1.0
		)
		var bounce_angle := deg_to_rad(max_bounce_angle) * hit_offset
		velocity = Vector2(sin(bounce_angle), -cos(bounce_angle)) * speed()
	elif collision.get_collider().is_in_group("bricks"):
		var brick = collision.get_collider()
		var normal = collision.get_normal()
		brick_destroyed.emit()
		brick.queue_free()
		wall_bounce(normal)
	else:
		wall_bounce(collision.get_normal())

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("launch"):
		launch(Vector2.UP * current_speed)
		
func is_waiting_for_launch():
	return _waiting_for_launch

func is_lost(boundaries: Rect2):
	var was_ball_lost: bool = boundaries.has_point(position) or boundaries.size.y < position.y
	if was_ball_lost:
		lost.emit()
	return was_ball_lost

func launch(vector: Vector2):
	set_velocity(vector)
	_waiting_for_launch = false
	
func wall_bounce(normal: Vector2):
	velocity = velocity.bounce(normal)
