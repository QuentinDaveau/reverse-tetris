extends Light2D


func _process(delta: float) -> void:
	randomize()
	if randf() > 0.95:
		energy = 1.2
	else:
		energy = 2
