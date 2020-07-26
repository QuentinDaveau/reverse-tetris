extends Node2D
class_name ScoreCounter

export(bool) var _is_demo = false

var _speed: float = 0.0
var _total_score: float = 0.0
var _damp: float = 200.0
var _wheels: Array = []


func _ready() -> void:
	for child in get_children():
		if child is ScoreWheel:
			_wheels.append(child)


func _process(delta: float) -> void:
	if _is_demo:
		return
	
	var floored_score = floor(_total_score / 128)
	_total_score += _speed * delta
	
	if (_total_score / 128) - floored_score > 1:
		if _speed / 1280 > 3:
			$ClickSound.pitch_scale = 1.56
		else:
			$ClickSound.pitch_scale = 1 + pow(_speed / (1280 * 4), 2)
		$ClickSound.play()
	
	if _speed > 0:
		_speed -= (_damp + (_speed / 5)) * delta
		if _speed < 0:
			_speed = 0;
	for wheel in _wheels:
		wheel.set_cursor(fmod((_total_score / pow(10, wheel.decimal)), 1280))
	$SparkParticles.set_speed(_speed)


func add_speed(speed: float) -> void:
	_speed += speed
