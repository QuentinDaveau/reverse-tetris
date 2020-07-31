extends Node

export(String, DIR) var _samples_path: String

onready var _samples_players: Array = [$Player1, $Player2, $Player3, $Player4, $Player5, 
		$Player6, $Player7, $Player8, $Player9, $Player10, $Player11, $Player12]
var _use_player_two: bool = false
var _sample_level: int = 0
var _player: AudioStreamPlayer


func _ready() -> void:
#	_charge_samples_path()
	play()


func play() -> void:
	yield(get_tree().create_timer(2), "timeout")
	$Timer.start()
	_on_Timer_timeout()


func stop() -> void:
	yield(get_tree().create_timer(5), "timeout")
	$Timer.stop()
#	$Player1.stop()
#	$Player2.stop()


func update_step(step: int) -> void:
	_sample_level = step


# The .ogg files doesn't export correctly under Godot 3.2.2, so I need to have
# one player per sample
#func _charge_samples_path() -> void:
#	var dir := Directory.new()
#	dir.open(_samples_path)
#	dir.list_dir_begin()
#	while true:
#		var file_name := dir.get_next()
#		print(file_name)
#		if file_name == "":
#			break;
#		if dir.current_is_dir():
#			continue
#		if file_name.get_extension() == "ogg":
#			print(_samples_path + "/" + file_name)
#			_samples.append(load(_samples_path + "/" + file_name))
#	dir.list_dir_end()


func _on_Timer_timeout() -> void:
	var level = _sample_level
	if _sample_level > 5:
		return
	if _use_player_two:
		level += 6
#		_player = $Player1
		_use_player_two = false
	else:
#		_player = $Player1
		_use_player_two = true
	_samples_players[level].play()

