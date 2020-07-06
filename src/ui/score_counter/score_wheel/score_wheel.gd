extends Node2D
class_name ScoreWheel

export(int) var decimal = 0

func set_cursor(new_position: float) -> void:
	$Sprite.region_rect.position.y = new_position + 128
