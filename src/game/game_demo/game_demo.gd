extends Node2D


func _enter_tree() -> void:
	Engine.time_scale = 0.3
	AudioServer.set_bus_effect_enabled(0, 1, true)


func _exit_tree() -> void:
	Engine.time_scale = 1
	AudioServer.set_bus_effect_enabled(0, 1, false)


func get_score_counter() -> Node:
	return $ScoreCounter


func get_camera() -> Node:
	return $GameCamera
