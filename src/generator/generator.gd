extends Node
class_name Generator

signal queue_updated(queue)

export(String, DIR) var _bricks_folder: String

var _bricks_instances: Array = []
var _bricks_queue: Array = []
var _queue_length: int = 3


func _enter_tree() -> void:
	randomize()
	_charge_brick_paths()
	for i in range(_queue_length):
		_instance_random_brick()


func get_queue() -> Array:
	return _bricks_queue


func pick_brick() -> Brick:
	var brick = _bricks_queue.pop_front()
	_instance_random_brick()
	return brick


func _charge_brick_paths() -> void:
	var dir := Directory.new()
	dir.open(_bricks_folder)
	dir.list_dir_begin()
	while true:
		var file_name := dir.get_next()
		if file_name == "":
			break;
		if dir.current_is_dir():
			continue
		if file_name.get_extension() == "tscn":
			_bricks_instances.append(load(_bricks_folder + "/" + file_name))
	dir.list_dir_end()


func _instance_random_brick() -> void:
	var brick: Brick = _bricks_instances[randi()%_bricks_instances.size()].instance()
	brick.setup()
	
	if _bricks_queue.size() > 0:
		while brick.get_blocks() == _bricks_queue.back().get_blocks():
			brick = _bricks_instances[randi()%_bricks_instances.size()].instance()
			brick.setup()
	
	_bricks_queue.append(brick)
	emit_signal("queue_updated", _bricks_queue)
