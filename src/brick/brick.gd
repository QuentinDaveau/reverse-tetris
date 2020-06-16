extends Node
class_name Brick

export(String, FILE, "*.tscn") var _block_path: String
export(bool) var _can_rotate: bool = true
export(PoolVector2Array) var _blocks: PoolVector2Array
export(Color) var blocks_color: Color

var _block_instance: Resource

var _block_models: Array = []

func setup() -> void:
	_block_instance = load(_block_path)
	for i in range(_blocks.size()):
		_block_models.append(_block_instance.instance())


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


func get_block_models() -> Array:
	return _block_models


func explode() -> void:
	for block in _block_models:
		block.explode()
	queue_free()
