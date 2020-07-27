extends CanvasLayer


func load_menu() -> void:
	_load_scene("res://src/menu/MainMenu.tscn")


func load_game() ->void:
	_load_scene("res://src/game/Game.tscn")


func _load_scene(scene_path: String) -> void:
	$Tween.interpolate_property($Control/ColorRect, "color:a", 0, 1, 
			1 * Engine.time_scale, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.interpolate_method(self, "_change_volume", 0.0, -40.0, 
			1 * Engine.time_scale, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")

	assert(get_tree().change_scene(scene_path) == OK)
	yield(get_tree().create_timer(0.1), "timeout")
	
	$Tween.interpolate_property($Control/ColorRect, "color:a", 1, 0, 
			1 * Engine.time_scale, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.interpolate_method(self, "_change_volume", -60.0, 0.0, 
			1 * Engine.time_scale, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")


func _change_volume(volume: float) -> void:
	AudioServer.set_bus_volume_db(0, volume)
