extends Node2D

signal exploded()

var _spawning: bool = true


func _ready() -> void:
	$Tween.interpolate_property($Sprite, "scale:x", 5.0, $Sprite.scale.x, 0.3, 
			Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property($Sprite, "modulate:a", 0, 1, 0.3, 
		Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	_spawning = false


func disable_visible_limit() -> void:
	$Sprite.get_material().set_shader_param("Limit", false)


func move(aimed_position: Vector2) -> void:
	$MoveSound.pitch_scale = Engine.time_scale * rand_range(0.8, 1.2)
	$MoveSound.play()
	if _spawning:
		global_position = aimed_position
		return
	$Tween.interpolate_property(self, "global_position", global_position,
			aimed_position, 0.1, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$Tween.start()


func update_shader(line_delay: float) -> void:
	$Sprite.get_material().set_shader_param("delay", line_delay)


func set_color(new_color: Color) -> void:
	$Sprite.get_material().set_shader_param("ColorModulator", new_color)


func explode(play_sound: bool = true) -> void:
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate * Color(1, 1, 1, 1) * 5,
			$Sprite.modulate * 5 * Color(1, 1, 1, 0), 0.2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
#	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale,
#			$Sprite.scale * 1.2, 0.5, Tween.TRANS_CIRC, Tween.EASE_OUT)
	$Tween.start()
	if play_sound:
		$ShootSound.pitch_scale = Engine.time_scale * rand_range(0.9, 1.1)
		$ShootSound.play()
	yield($Tween, "tween_all_completed")
	emit_signal("exploded")
	queue_free()
