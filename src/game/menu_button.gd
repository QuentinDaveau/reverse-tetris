extends TextureButton


func _on_TextureButton_pressed() -> void:
	$ButtonClick.play()
	SceneManager.load_menu()


func _on_TextureButton_mouse_entered() -> void:
	$ButtonHover.play()
