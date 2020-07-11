extends Light2D

var time: float = 0.0


func _process(delta: float) -> void:
	delta /= Engine.time_scale
	time += delta
	
	color = Color((sin(time * 0.156) + 1)/2,
			(sin(time * 0.3195) + 1)/2,
			(sin(time * 0.7152) + 1)/2)
