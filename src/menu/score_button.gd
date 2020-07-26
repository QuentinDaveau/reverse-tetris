extends TextureButton


func _on_ScoreButton_pressed() -> void:
	$ButtonClick.play()


func _on_ScoreButton_mouse_entered() -> void:
	$ButtonHover.play()
