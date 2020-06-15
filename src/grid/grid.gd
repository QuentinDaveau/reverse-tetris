extends Node2D

export(int) var _rows: int = 8
export(int) var _columns: int = 20

export(float) var _cell_size: float
export(String, FILE, "*.tscn") var _player_path: String
export(String, FILE, "*.tscn") var _block_path: String

onready var _block = load(_block_path)

# 2D array, 0 = empty, 1 = block
# Columns then rows
var cells: Array = []
var _player: Player

var _wall_delay: int = 0
var _block_move_delay: float = 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(_columns):
		cells.append([])
		for j in range(_rows):
			cells[i].append(0)
	var player: Player = load(_player_path).instance()
	player.setup(Vector2(0, round(_rows / 2)), self, get_parent().get_node("Generator"))
	cells[0][round(_rows / 2)] = 2
	_player = player
	add_child(player)
	_push_wall(3)


func move(direction: String, entity_position: Vector2) -> Vector2:
	var col := entity_position.x
	var row := entity_position.y
	
#	if not cells[col][row]:
#		return entity_position
	
	match direction:
		"right":
			return _check_and_move(entity_position, Vector2(col, row + 1))
		"left":
			return _check_and_move(entity_position, Vector2(col, row - 1))
		"down":
			return _check_and_move(entity_position, Vector2(col - 1, row))
		"up":
			return _check_and_move(entity_position, Vector2(col + 1, row))
	return entity_position


func project_brick(brick: Brick, row: int) -> Vector2:
	if row < 0 or row >= _rows:
		return - Vector2.ONE
	for i in range(_columns):
		for block in brick.get_blocks():
			if i + block.y < 0 or i + block.y >= _columns:
				continue
			if cells[i + block.y][int(_rows + row + block.x) % _rows] is Block:
				return Vector2(i - 1, row)
	return - Vector2.ONE


func shoot_brick(brick: Brick, row: int) -> bool:
	var hit_position := project_brick(brick, row)
	if hit_position == -Vector2.ONE:
		return false
	var neighbours: PoolVector2Array = []
	for block in brick.get_blocks():
		neighbours.append_array(_find_neighbour(Vector2(hit_position.x + block.y, int(_rows + hit_position.y + block.x) % _rows)))
	for pos in neighbours:
		_destroy_block(Vector2(pos.x, pos.y))
		cells[pos.x][pos.y] = 0
	_push_wall(1)
	update()
	return true


func _push_wall(amount: int) -> void:
	if amount == 1:
		if _wall_delay < 2:
			_wall_delay += 1
			return
		else:
			_wall_delay = 0
	var first_move: int = -1
	for n in range(amount):
		for i in range(_columns):
			for j in range(_rows):
				if cells[i][j] is Block:
					if first_move == -1:
						first_move = i
					cells[i - 1][j] = cells[i][j]
					cells[i][j].update_position(_convert_to_world_position(Vector2(i - 1, j)), (i - first_move) * _block_move_delay)
					cells[i][j] = 0
			if i == _columns - 1:
				for j in range(_rows):
					if first_move == -1:
						first_move = i
					cells[i][j] = _instance_block(Vector2(i, j), (1 +i - first_move) * _block_move_delay)
	update()


func _instance_block(grid_position: Vector2, block_show_delay) -> Block:
	if cells[grid_position.x][grid_position.y] != 0:
		return null
	var block : Block = _block.instance()
	add_child(block)
	block.global_position = _convert_to_world_position(grid_position)
	block.complete_spawn(block_show_delay)
	return block


func _destroy_block(grid_position: Vector2) -> void:
	if not cells[grid_position.x][grid_position.y] is Block:
		return
	cells[grid_position.x][grid_position.y].explode()
	cells[grid_position.x][grid_position.y] = 0


func _convert_to_world_position(grid_position: Vector2) -> Vector2:
	return global_position + (Vector2(grid_position.y, -grid_position.x) * _cell_size)


func _find_neighbour(search_position: Vector2) -> PoolVector2Array:
	var neighbours: PoolVector2Array = []
	for i in range(-1, 3, 2):
		if search_position.x + i >= _columns:
			continue
		if cells[search_position.x + i][search_position.y] is Block:
			neighbours.append(Vector2(search_position.x + i, search_position.y))
		for j in range(-1, 3, 2):
			if cells[search_position.x][int(search_position.y + j) % _rows] is Block:
				neighbours.append(Vector2(search_position.x, int(_rows + search_position.y + j) % _rows))
	return neighbours


func _check_and_move(current_position: Vector2, new_position: Vector2) -> Vector2:
	if not cells[int(_columns + new_position.x) % _columns][int(_rows + new_position.y) % _rows]:
		cells[int(_columns + new_position.x) % _columns][int(_rows + new_position.y) % _rows] = cells[current_position.x][current_position.y]
		cells[current_position.x][current_position.y] = 0
		update()
		_push_wall(1)
		return Vector2(int(_columns + new_position.x) % _columns, int(_rows + new_position.y) % _rows)
	else:
		return current_position


func _draw() -> void:
#	for i in range(_columns + 1):
#		draw_line(Vector2(0, - i * _cell_size), Vector2(_cell_size * _rows + 1, - i * _cell_size), Color.black)
#		for j in range(_rows + 1):
#			draw_line(Vector2(j * _cell_size, 0), Vector2(j * _cell_size, -(_cell_size * _columns + 1)), Color.black)
#	for i in range(_columns):
#		for j in range(_rows):
#			if cells[i][j] is Block:
#				draw_rect(Rect2(Vector2(j * _cell_size + 2, -i * _cell_size - 2), Vector2(1, -1) * (_cell_size - 4)), Color.green)
#			if cells[i][j] is Player:
#				draw_rect(Rect2(Vector2(j * _cell_size + 2, -i * _cell_size - 2), Vector2(1, -1) * (_cell_size - 4)), Color.red)
	var pos = project_brick(_player._current_brick, _player._current_position.y)
	for block in _player._current_brick.get_blocks():
		draw_rect(Rect2(Vector2(2 + (int(_rows + pos.y + block.x) % _rows) * _cell_size, -2 - (pos.x + block.y) * _cell_size), Vector2(1, -1) * (_cell_size - 5)), Color.blue)

