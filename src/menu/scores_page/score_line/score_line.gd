extends Panel


func setup(player: String, score: String, date: String) -> void:
	$MarginContainer/HBoxContainer/Player.text = player
	$MarginContainer/HBoxContainer/Score.text = score
	$MarginContainer/HBoxContainer/Date.text = date
