class_name ScoreHUD
extends Control

@export var bricks_left: Label
@export var balls_left: Label


func set_balls_left(num: int):
	balls_left.text = str(num)

func set_bricks_left(num: int):
	bricks_left.text = str(num)
