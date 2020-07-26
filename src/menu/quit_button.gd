extends TextureButton


func _on_QuitButton_pressed() -> void:
	$ButtonClick.play()


func _on_QuitButton_mouse_entered() -> void:
	$ButtonHover.play()
