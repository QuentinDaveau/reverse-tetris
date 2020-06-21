extends Node

var _game_camera: Camera2D


func _ready() -> void:
	_game_camera = get_tree().get_root().find_node("GameCamera", true, false)


func get_camera() -> Camera2D:
	return _game_camera
