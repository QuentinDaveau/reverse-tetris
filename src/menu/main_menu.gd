extends Node2D

var _camera_on_scores: bool = false


func _transition_scores() -> void:
	if not _camera_on_scores:
		$CameraTween.interpolate_property($Camera2D, "position:y", 300, 900, 0.15, 
				Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		$ScoresPage.refresh()
		_camera_on_scores = true
	else:
		$CameraTween.interpolate_property($Camera2D, "position:y", 900, 300, 0.15, 
				Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		_camera_on_scores = false
	$CameraTween.start()


func _on_PlayButton_pressed() -> void:
	SceneManager.load_game()


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_ScoreButton_pressed() -> void:
	_transition_scores()


func _on_GoBackButton_pressed() -> void:
	_transition_scores()
