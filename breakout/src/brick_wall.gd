class_name BrickWall
extends Node2D


func kill_all_children():
	for child in get_children():
		child.queue_free()

func restart():
	kill_all_children()
	var brick_scene = load("res://scenes/brick.tscn")
	var margin = 10
	var sample_brick = brick_scene.instantiate()
	var bricks_per_row = get_viewport_rect().size.x / (sample_brick.get_size().x + margin)
	var remaining_x_space: float = (int(get_viewport_rect().size.x) % int((sample_brick.get_size().x + margin))) / 2
	var num_of_rows = 5
	var start_row = 4
	var row_colors = [
		Color("#d82800"), # red-orange
		Color("#f8b800"), # gold
		Color("#00a800"), # green
		Color("#0078f8"), # blue
		Color("#a800f8")  # purple
	]
	for row in range(start_row, start_row + num_of_rows):
		for column in range(bricks_per_row):
			var brick = brick_scene.instantiate()
			var half_brick = brick.get_size() / 2
			var x = (brick.get_size().x * column) + (margin * column) + half_brick.x + remaining_x_space
			var y = brick.get_size().y * row + (margin * row) + half_brick.y
			brick.position = Vector2(x, y)
			brick.set_color(row_colors[row % len(row_colors)])
			add_child(brick)
	return bricks_per_row * num_of_rows
