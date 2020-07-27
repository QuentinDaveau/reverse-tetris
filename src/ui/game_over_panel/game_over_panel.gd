extends Node2D

const ALLOWED_CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 -_"

onready var _score_label = $Control/CenterContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel
onready var _message_label = $Control/CenterContainer/MarginContainer/MarginContainer/VBoxContainer/MessageLabel
onready var _user_name = $Control/CenterContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/UserNameLine
onready var _send_score = $Control/CenterContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer2/SendScoreButton
onready var _replay = $Control/CenterContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/ReplayButton
onready var _menu = $Control/CenterContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3/MenuButton
onready var _status_text = $Control/CenterContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer4/StatusText
onready var _refresh_button = $Control/CenterContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer4/RefreshButton

var _time: float = 0.0
var _score: int = 0
var _score_sent: bool = false
var _name_entered: bool = false


func _process(delta: float) -> void:
	delta /= Engine.time_scale
	_time += delta
	_score_label.add_color_override("font_color_shadow", Color((sin(_time * 0.256) + 1)/3,
			(sin(_time * 0.6851) + 1)/3,
			(sin(_time * 1.4586) + 1)/3))


func focus() -> void:
	if not GameParams.player_name:
		_user_name.grab_focus()
		_send_score.disabled = true
	else:
		_user_name.text = GameParams.player_name


func set_score(score: int) -> void:
	_score_label.text = String(score)
	_score = score
	
	if score < 500:
		_message_label.text = "That's a start!"
	if score >= 500 && score < 1000:
		_message_label.text = "Getting there!"
	if score >= 1000 && score < 1500:
		_message_label.text = "Pretty good!"
	if score >= 1500 && score < 2000:
		_message_label.text = "Well done!"
	if score >= 2000 && score < 2500:
		_message_label.text = "Excellent!"
	if score >= 2500 && score < 3000:
		_message_label.text = "It's something!"
	if score >= 3000 && score < 3500:
		_message_label.text = "Wow!"
	if score >= 3500 && score < 4000:
		_message_label.text = "Even more !?"
	if score >= 4000 && score < 5000:
		_message_label.text = "Still going !?"
	if score >= 5000:
		_message_label.text = "But... How !?"



func _on_SendScoreButton_pressed() -> void:
	if _score_sent:
		return
	GameParams.player_name = _user_name.text
	_send_score.disabled = true
	_status_text.text = "Sending score..."
	_name_entered = true
	_user_name.release_focus()
	_user_name.editable = false
	$HTTPScoreClient.send_score(_score, _user_name.text)


func _on_ReplayButton_pressed() -> void:
	SceneManager.load_game()


func _on_MenuButton_pressed() -> void:
	SceneManager.load_menu()


func _on_HTTPScoreClient_request_treated(status, value) -> void:
	if status:
		_score_sent = true
		_status_text.text = "Success! Your rank is: " + String(value[0])
		_refresh_button.disabled = true
		_refresh_button.visible = false
	else:
		_status_text.text = "Failed to send score :("
		_refresh_button.disabled = false
		_refresh_button.visible = true
	_menu.disabled = false
	_replay.disabled = false


func _on_UserNameLine_text_changed(new_text: String) -> void:
	if _name_entered:
		return
	
	var s := ""
	for c in new_text:
		if  c in ALLOWED_CHARS:
			s += c
	_user_name.text = s
	_user_name.caret_position = _user_name.text.length()
	
	if _user_name.text.length() > 0:
		if _send_score.disabled:
			_send_score.disabled = false
	else:
		if !_send_score.disabled:
			_send_score.disabled = true


func _on_RefreshButton_pressed() -> void:
	_status_text.text = "Sending score to server..."
	_refresh_button.disabled = true
	_refresh_button.visible = false
	$HTTPScoreClient.send_score(_score, _user_name.text)
