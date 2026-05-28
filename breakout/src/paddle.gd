class_name Paddle
extends CharacterBody2D

@export var speed_ratio: float = 1.25
@export var collision_shape: CollisionShape2D

func speed() -> float:
	return get_viewport_rect().size.y * speed_ratio

func get_paddle_size():
	return collision_shape.shape.get_rect().size

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed()
	else:
		velocity.x = 0

	move_and_slide()
