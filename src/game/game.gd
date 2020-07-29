extends Node2D


func get_score_counter() -> Node:
	return $ScoreCounter


func get_camera() -> Node:
	return $GameCamera


func _on_ScoreCounter_wheel_final_stop(final_score) -> void:
	$MenuButton/Control/CenterContainer/TextureButton.disabled = true
	$GameOverPanel.focus()
	$GameOverPanel.set_score(final_score)
	$GameOverPanel/Tween.interpolate_property($GameOverPanel, "position:y", $GameOverPanel.position.y,
			0.0, 0.5, Tween.TRANS_BACK, Tween.EASE_OUT, 1)
	$Node2D/ColorRect.visible = true
	$GameOverPanel/Tween.interpolate_property($Node2D/ColorRect, "color:a", 0,
			0.6, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT, 1)
	$GameOverPanel/Tween.start()
