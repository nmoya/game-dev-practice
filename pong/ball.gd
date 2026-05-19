class_name Ball
extends CharacterBody2D

@export var speed_ratio: float = 1
@export var max_bounce_angle: float = 60

func speed():
	return get_viewport_rect().size.y * speed_ratio

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	
	if not collision:
		return
	if collision.get_collider().is_in_group("paddles"):
		var paddle := collision.get_collider()
		var paddle_height = paddle.get_paddle_size().y
		var hit_offset: float = clamp((position.y - paddle.position.y) / (paddle_height / 2.0), -1.0, 1.0)
		var bounce_angle = deg_to_rad(max_bounce_angle) * hit_offset
		var x_direction = sign(position.x - paddle.position.x)
		velocity = Vector2(x_direction * cos(bounce_angle), sin(bounce_angle)) * speed()
	else:
		velocity = velocity.bounce(collision.get_normal())

func reset_to(center: Vector2) -> void:
	position = center

func start() -> void:
	velocity = Vector2([-1, 1].pick_random(), [-1, 1].pick_random()).normalized() * speed()

func pause() -> Vector2:
	var current = velocity
	stop()
	return current
	
func resume(old_velocity: Vector2) -> void:
	velocity = old_velocity

func stop() -> void:
	velocity = Vector2(0, 0)
