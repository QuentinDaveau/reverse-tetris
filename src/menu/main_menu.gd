extends Node2D

var _camera_on_bottom: bool = false


func _transition_scores(show_scores: bool = true) -> void:
	if not _camera_on_bottom:
		$CameraTween.interpolate_property($Camera2D, "position:y", 300, 900, 0.15, 
				Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		if show_scores:
			$ScoresPage.visible = true
			$AboutPage.visible = false
			$ScoresPage.refresh()
		else:
			$ScoresPage.visible = false
			$AboutPage.visible = true
		_camera_on_bottom = true
	else:
		$CameraTween.interpolate_property($Camera2D, "position:y", 900, 300, 0.15, 
				Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		_camera_on_bottom = false
		$ScoresPage.tidy()
	$CameraTween.start()


func _on_PlayButton_pressed() -> void:
	SceneManager.load_game()


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_ScoreButton_pressed() -> void:
	_transition_scores()


func _on_GoBackButton_pressed() -> void:
	_transition_scores()


func _on_AboutButton_pressed() -> void:
	_transition_scores(false)


func _on_TextureButton_pressed() -> void:
	_transition_scores()
