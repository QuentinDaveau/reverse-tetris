extends Camera2D

const SHAKE_THRESHOLD: float = 0.5

export(float) var _shake_damp: float = 0.7
export(float) var _shake_noise: float = 0.1
export(float) var _shake_speed: float = 0.03

export(bool) var _shake_enabled: bool = true

var _shake_amount: Vector2 = Vector2.ZERO


func _ready() -> void:
	$Shaker.connect("tween_all_completed", self, "_shake_move_completed")


func add_shake(amount: float) -> void:
	if not _shake_enabled:
		return
	randomize()
	var vec_amount := (Vector2(randf(), randf()) - Vector2(0.5, 0.5)) * 2.0 * amount
	
	if sign(_shake_amount.x):
		_shake_amount.x += vec_amount.x * sign(_shake_amount.x)
	else:
		_shake_amount.x += vec_amount.x
	if sign(_shake_amount.y):
		_shake_amount.y += vec_amount.y * sign(_shake_amount.y)
	else:
		_shake_amount.y += vec_amount.y
	_shake()


func _shake_move_completed() -> void:
	if not _shake_amount:
		return
	randomize()
	_shake_amount = (-_shake_amount * (1 - _shake_damp)).rotated(rand_range(-PI/2 * _shake_noise, PI/2 * _shake_noise))
	if _shake_amount.length() < SHAKE_THRESHOLD:
		_shake_amount = Vector2.ZERO
	_shake()


func _shake() -> void:
	$Shaker.interpolate_property(self, "offset", offset, _shake_amount, _shake_speed, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	$Shaker.start()
