extends Node2D

const SEP_DIST: int = 200
const BLOCK_SCENE = preload("res://src/block/HologramBlock/HologramBlock.tscn")

var _generator: Generator

var _next_brick: Array


func _on_Generator_queue_updated(queue: Array) -> void:
	if queue.size() < 3:
		return
	for block in _next_brick:
		block.explode(false)
	_next_brick.clear()
	var i: int = 0
	for block in queue[0].get_block_models():
		var block_d: Node2D = BLOCK_SCENE.instance()
		block_d.set_color(queue[0].get_blocks_color())
		var blocks_pos = queue[0].get_blocks()
		var moy := Vector2.ZERO
		for pos in blocks_pos:
			moy += pos
		moy /= blocks_pos.size()
		_next_brick.append(block_d)
		block_d.disable_visible_limit()
		add_child(block_d)
		block_d.position = (blocks_pos[i] - moy) * 32 * Vector2(1, -1)
		i += 1
