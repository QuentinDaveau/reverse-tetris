extends TextureButton

func _on_TextureButton_pressed() -> void:
	$ButtonClick.play()


func _on_TextureButton_mouse_entered() -> void:
	$ButtonHover.play()
