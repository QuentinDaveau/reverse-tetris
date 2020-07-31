extends Node

const SAMPLES_PATH : String = "res://assets/music_samples/"

var _samples: Array = []
var _use_player_two: bool = false
var _sample_level: int = 0


func _ready() -> void:
	_charge_samples_path()


func play() -> void:
	pass


func stop() -> void:
	pass


func update_level(level: int) -> void:
	pass


func _charge_samples_path() -> void:
	var dir := Directory.new()
	dir.open(SAMPLES_PATH)
	dir.list_dir_begin()
	while true:
		var file_name := dir.get_next()
		if file_name == "":
			break;
		if dir.current_is_dir():
			continue
		if file_name.get_extension() == "ogg":
			_samples.append(SAMPLES_PATH + "/" + file_name)
	dir.list_dir_end()


func _on_Timer_timeout() -> void:
	var _player: AudioStreamPlayer
	if _use_player_two:
		_player = $Player2
	else:
		_player = $Player1
	_player.stream = _samples[_sample_level]
	_player.play()

