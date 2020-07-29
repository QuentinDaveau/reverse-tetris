extends TextureButton


func _on_AboutButton_pressed() -> void:
	$ButtonClick.play()


func _on_AboutButton_mouse_entered() -> void:
	$ButtonHover.play()
