extends Node2D

var lamp_color: Color = Color.darkgray

func set_player_position(position_index: int) -> void:
	$PlayerLamp.self_modulate = Color.darkgray
	$PlayerLamp/Light2D.color = Color.black
	$Tween.interpolate_property($PlayerLamp, "position:x", $PlayerLamp.position.x,
			(position_index * 32) - 112.056, 0.1, Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$PlayerLamp.self_modulate = lamp_color * 2
	$PlayerLamp/Light2D.color = lamp_color


func set_player_color(new_color: Color) -> void:
	lamp_color = new_color
	$PlayerLamp.self_modulate = Color.darkgray
	$PlayerLamp/Light2D.color = Color.black
	$PlayerLamp/Timer.start(0.1)
	yield($PlayerLamp/Timer, "timeout")
	$PlayerLamp.self_modulate = new_color * 2
	$PlayerLamp/Light2D.color = new_color
