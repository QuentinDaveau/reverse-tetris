extends Panel


func setup(rank: String, player: String, score: String, date: String) -> void:
	$MarginContainer/HBoxContainer/Rank.text = rank
	$MarginContainer/HBoxContainer/Player.text = player
	$MarginContainer/HBoxContainer/Score.text = score
	$MarginContainer/HBoxContainer/Date.text = date
