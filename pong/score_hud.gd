class_name ScoreHUD
extends HBoxContainer

@onready var left_score: Label = %LeftScore
@onready var right_score: Label = %RightScore

func set_score(left: int, right: int):
	left_score.text = str(left)
	right_score.text = str(right)
