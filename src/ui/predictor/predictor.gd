extends Node2D

const SEP_DIST: int = 200

var _generator: Generator

var _next_brick: Array


func _on_Generator_queue_updated(queue: Array) -> void:
	if queue.size() < 3:
		return
	for block in _next_brick:
		block.explode()
	_next_brick.clear()
	var i: int = 0
	for block in queue[0].get_block_models():
		var block_d: Node2D = block.duplicate()
		var blocks_pos = queue[0].get_blocks()
		var moy := Vector2.ZERO
		for pos in blocks_pos:
			moy += pos
		moy /= blocks_pos.size()
		_next_brick.append(block_d)
		add_child(block_d)
		block_d.position = (blocks_pos[i] - moy) * 32 * Vector2(1, -1)
		i += 1
