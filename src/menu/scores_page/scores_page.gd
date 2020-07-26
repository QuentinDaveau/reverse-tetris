extends Node2D

var _score_line = preload("res://src/menu/scores_page/score_line/ScoreLine.tscn")
onready var _lines_container = $Control/MarginContainer/VBoxContainer/ScrollContainer/ScoreLinesContainer

func _ready() -> void:
	refesh()

func refesh() -> void:
	$HTTPScoreClient.get_scores()
	var answer = yield($HTTPScoreClient, "request_treated")
	if not answer[0]:
		return
	var scores = answer[1]
	if scores.size() <= 0:
		return
	for child in _lines_container.get_children():
		child.queue_free()
	for line in scores:
		var new_line = _score_line.instance()
		new_line.setup(line[0], line[1], line[2])
		_lines_container.add_child(new_line)
