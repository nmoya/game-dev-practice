extends CharacterBody2D

const SPEED = 750
const bullet_scene = preload("res://src/bullet.tscn")


func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action("shoot"):
		var bullet = bullet_scene.instantiate()
		print("Bullet was shot")

func _space_invaders_on_resize(viewport: Vector2) -> void:
	position = Vector2(viewport.x / 2, viewport.y - (viewport.y * 0.1))
