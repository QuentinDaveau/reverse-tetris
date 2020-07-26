extends TextureButton


func _on_PlayButton_pressed() -> void:
	$ButtonClick.play()


func _on_PlayButton_mouse_entered() -> void:
	$ButtonHover.play()
