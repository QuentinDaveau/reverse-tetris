extends Node2D
class_name Player

export(String, FILE, "*.tscn") var brick_path

var _current_position: Vector2
var _grid: Node2D
var _current_brick: Brick
var _generator: Generator


func setup(start_position: Vector2, grid: Node2D, generator: Generator) -> void:
	_current_position = start_position
	_grid = grid
	_generator = generator


func _ready() -> void:
	_current_brick = _generator.pick_brick()
	for block in _current_brick.get_block_models():
		_grid.add_child(block)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		_current_position = _grid.move("left", _current_position)
		_grid.update_player_proj()
	if Input.is_action_just_pressed("ui_right"):
		_current_position = _grid.move("right", _current_position)
		_grid.update_player_proj()
	if Input.is_action_just_pressed("game_rotate"):
		_current_brick.rotate()
		_grid.update_player_proj()
	if Input.is_action_just_pressed("ui_accept"):
		_grid.shoot_brick(_current_brick, _current_position.y)
		_current_brick.explode()
		_current_brick = _generator.pick_brick()
		for block in _current_brick.get_block_models():
			_grid.add_child(block)
		_grid.update_player_proj()
