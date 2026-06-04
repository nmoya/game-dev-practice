extends Node2D


signal on_resize

func _ready() -> void:
	var screen_size = get_viewport_rect().size
	on_resize.emit(screen_size)
