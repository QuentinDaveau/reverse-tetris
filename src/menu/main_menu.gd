extends Node2D

#onready var _game = preload("res://src/game/Game.tscn")

func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://src/game/Game.tscn")


func _on_QuitButton_pressed() -> void:
	pass # Replace with function body.
