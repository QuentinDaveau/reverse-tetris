extends Node2D
class_name Block

var _explode_delay: float = 0.2
var _move_speed: float = 0.35


func complete_spawn(wait_time: float) -> void:
	if wait_time > 0:
		$MoveTimer.start(wait_time)
		yield($MoveTimer, "timeout")
	$Sprite.visible = true


func update_position(new_position: Vector2, wait_time: float) -> void:
	randomize()
	if wait_time > 0:
		$MoveTimer.start(wait_time)
		yield($MoveTimer, "timeout")
	$Tween.interpolate_property(self, "global_position", global_position,
		new_position, _move_speed, Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "scale:x", 1, 0.5, 
		_move_speed / 3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "scale:x", 0.5, 1, 
		2 * _move_speed / 3, Tween.TRANS_BACK, Tween.EASE_OUT, _move_speed / 3)
	$Tween.start()


func explode() -> void:
	randomize()
	$ExplodeTimer.start(randf() * _explode_delay)
	yield($ExplodeTimer, "timeout")
	queue_free()
