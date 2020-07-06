extends Node

var _score_counter: ScoreCounter


func _ready() -> void:
	_score_counter = get_tree().get_root().find_node("ScoreCounter", true, false)


func get_counter() -> ScoreCounter:
	return _score_counter
