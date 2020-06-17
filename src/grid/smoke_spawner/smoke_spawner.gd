extends Particles2D

func smoke() -> void:
	emitting = true
	$Timer.start(lifetime)
	yield($Timer, "timeout")
	queue_free()
