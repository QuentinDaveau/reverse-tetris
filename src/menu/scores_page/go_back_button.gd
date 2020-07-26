extends TextureButton


func _on_GoBackButton_mouse_entered() -> void:
	$ButtonHover.play()


func _on_GoBackButton_pressed() -> void:
	$ButtonClick.play()
