extends Node2D


func _on_meta_clicked(meta) -> void:
	OS.shell_open(meta)
