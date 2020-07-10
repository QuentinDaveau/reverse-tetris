extends Player


func _ready() -> void:
	randomize()
	._ready()


func _process(delta: float) -> void:
	return


func _on_Timer_timeout() -> void:
	randomize()
	var r := randi() % 12
	match r:
		0:
			_current_brick.rotate()
			_grid.update_player_proj()
		1, 6:
			if _exploding:
				return
			_grid.shoot_brick(_current_brick, _current_position.y)
			var exploding_brick = _current_brick
			exploding_brick.explode()
			_exploding = true
			yield(exploding_brick, "exploded")
			_current_brick = _generator.pick_brick()
			_exploding = false
			for block in _current_brick.get_block_models():
				block.disable_visible_limit()
				_grid.add_child(block)
			_grid.update_player_proj()
			_player_slots.set_player_color(_current_brick.get_blocks_color())
		2, 3:
			_current_position = _grid.move("left", _current_position)
			_player_slots.set_player_position(_current_position.y)
			_grid.update_player_proj()
		4, 5:
			_current_position = _grid.move("right", _current_position)
			_grid.update_player_proj()
			_player_slots.set_player_position(_current_position.y)


