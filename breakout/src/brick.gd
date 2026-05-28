class_name Brick
extends StaticBody2D

@export var sprite: MeshInstance2D

func get_size():
	var quad_mesh = sprite.mesh as QuadMesh
	return quad_mesh.size

func set_color(color: Color):
	sprite.modulate = color
	
