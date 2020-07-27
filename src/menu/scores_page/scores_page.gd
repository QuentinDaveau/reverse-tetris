extends Node2D

var _score_line = preload("res://src/menu/scores_page/score_line/ScoreLine.tscn")
onready var _lines_container = $Control/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/ScoreLinesContainer
onready var _status_label = $Control/MarginContainer/VBoxContainer/OptionsContainer/StatusLabel
onready var _name_filter = $Control/MarginContainer/VBoxContainer/OptionsContainer/NameFilter
onready var _sort_type = $Control/MarginContainer/VBoxContainer/OptionsContainer/HBoxContainer/SortType


func refresh() -> void:
	_status_label.text = "Loading..."
	$HTTPScoreClient.get_scores(_name_filter.text, _sort_type.text)


func _update_list(scores: Array) -> bool:
	if scores.size() <= 0:
		return false
	for child in _lines_container.get_children():
		child.queue_free()
	var i := 1
	for line in scores:
		var new_line = _score_line.instance()
		new_line.setup(String(i), String(line[0]), String(line[1]), String(line[2]))
		_lines_container.add_child(new_line)
		i += 1
	return true


func _on_RefreshButton_pressed() -> void:
	refresh()


func _on_HTTPScoreClient_request_treated(status, value) -> void:
	if not status:
		_status_label.text = "Cannot connect to server :("
		return
	if _update_list(value):
		_status_label.text = "Done !"
	else:
		_status_label.text = "There's a bug somewhere :("
