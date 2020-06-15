extends Node
class_name Brick

export(bool) var _can_rotate: bool = true

export(PoolVector2Array) var _blocks: PoolVector2Array


func rotate(direction: int = 1) -> void:
	if not _can_rotate:
		return
	if direction != 1 and direction != -1:
		return
	var new_blocks: PoolVector2Array = []
	for block in _blocks:
		new_blocks.append(block.rotated(direction * PI / 2.0).round())
	_blocks = new_blocks


func get_blocks() -> PoolVector2Array:
	return _blocks
