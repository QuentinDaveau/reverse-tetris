extends Node2D

export(int) var _rows: int = 8
export(int) var _columns: int = 20

export(float) var _cell_size: float
export(String, FILE, "*.tscn") var _player_path: String
export(String, FILE, "*.tscn") var _block_path: String
export(String, FILE, "*.tscn") var _smoke_spawner_path: String
export(AudioStreamSample) var explosion_slow_mo

export(bool) var _is_demo: bool = false

onready var _block = load(_block_path)
onready var _smoke_spawner = load(_smoke_spawner_path)

# 2D array, 0 = empty, 1 = block
# Columns then rows
var cells: Array = []
var _player: Player

var _wall_delay: int = 0
var _block_move_delay: float = 0.04

var _highlighted_blocks: Array = []

var lost = false


func _ready() -> void:
	
	$Neon.scale = Vector2(_rows * _cell_size / 512, _columns * _cell_size / 1024)
	$Neon.position = Vector2(128 - _cell_size / 2, _cell_size / 2)
	
	for i in range(_columns):
		cells.append([])
		for j in range(_rows):
			cells[i].append(0)
	var player: Player = load(_player_path).instance()
	player.setup(Vector2(0, round(_rows / 2.0)), self, get_parent().get_node("Generator"))
	cells[0][round(_rows / 2.0)] = 2
	_player = player
	add_child(player)
	_push_wall(3)
	update_player_proj()


func move(direction: String, entity_position: Vector2) -> Vector2:
	var col := entity_position.x
	var row := entity_position.y
	
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
		if pos.x >= _columns - 1:
			continue
		_destroy_block(Vector2(pos.x, pos.y), brick.get_blocks_color())
		cells[pos.x][pos.y] = 0
	_push_wall(1)
	return true


func update_player_proj() -> void:
	var pos = project_brick(_player._current_brick, int(_player._current_position.y))
	var blocks = _player._current_brick.get_blocks()
	var models = _player._current_brick.get_block_models()
	for i in range(blocks.size()):
		models[i].move(_convert_to_world_position(Vector2(pos.x + blocks[i].y,
			int(_rows + pos.y + blocks[i].x) % _rows)))
		models[i].update_shader(blocks[i].y)
	
	var neighbours: PoolVector2Array = []
	for block in blocks:
		neighbours.append_array(_find_neighbour(Vector2(pos.x + block.y, int(_rows + pos.y + block.x) % _rows)))
	for block in _highlighted_blocks:
		if not block:
			continue
		block.highlight(Color.black)
	_highlighted_blocks = []
	for block in neighbours:
		cells[block.x][block.y].highlight(_player._current_brick.get_blocks_color())
		_highlighted_blocks.append(cells[block.x][block.y])


func _push_wall(amount: int) -> void:
	if amount == 1:
		if _wall_delay < 1:
			_wall_delay += 1
			return
		else:
			_wall_delay = 0
	var first_move: int = -1
	for n in range(amount):
		for i in range(_columns):
			for j in range(_rows):
				if cells[i][j] is Block:
					if i <= 2:
						lost = true
						_player.disable_input()
					if lost:
						if i >= _columns - 1:
							continue
						yield(get_tree().create_timer(0.03), "timeout")
						_destroy_block(Vector2(i,j), Color.white)
						continue
					if first_move == -1:
						first_move = i
					cells[i - 1][j] = cells[i][j]
					cells[i][j].update_position(_convert_to_world_position(Vector2(i - 1, j)), (i - first_move) * _block_move_delay)
					cells[i][j] = 0
			if i == _columns - 1:
				if lost:
					continue
				for j in range(_rows):
					if first_move == -1:
						first_move = i
					cells[i][j] = _instance_block(Vector2(i, j), (1 +i - first_move) * _block_move_delay)
	if lost:
		owner.get_score_counter().brake()


func _instance_block(grid_position: Vector2, block_show_delay) -> Block:
	if cells[grid_position.x][grid_position.y] != 0:
		return null
	var block : Block = _block.instance()
	if _is_demo:
		block.get_node("Sprite").get_material().set_shader_param("Limit", false)
		block.get_node("ExplosionSound").stream = explosion_slow_mo
	add_child(block)
	block.global_position = _convert_to_world_position(grid_position)
	block.complete_spawn(block_show_delay)
	return block


func _destroy_block(grid_position: Vector2, explosion_color: Color) -> void:
	if not cells[grid_position.x][grid_position.y] is Block:
		return
	_spawn_smoke(cells[grid_position.x][grid_position.y].global_position)
	cells[grid_position.x][grid_position.y].explode(explosion_color, 
			(grid_position.y * _cell_size) + (_cell_size / 2),
			((_rows - grid_position.y) * _cell_size) - (_cell_size / 2),
			(grid_position.x * _cell_size) - (_cell_size * 1.5),
			((_columns - grid_position.x) * _cell_size) - (_cell_size * 1.5))
	cells[grid_position.x][grid_position.y] = 0


func _spawn_smoke(spawner_pos: Vector2) -> void:
	var smoke = _smoke_spawner.instance()
	add_child(smoke)
	smoke.global_position = spawner_pos
	smoke.smoke()


func _convert_to_world_position(grid_position: Vector2) -> Vector2:
	return global_position + (Vector2(grid_position.y, -grid_position.x) * _cell_size)


func _find_neighbour(search_position: Vector2) -> PoolVector2Array:
	var neighbours: PoolVector2Array = []
	for i in range(-1, 3, 2):
		if search_position.x + i >= _columns:
			continue
		if search_position.x + i <= 0:
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
#		_push_wall(1)
		return Vector2(int(_columns + new_position.x) % _columns, int(_rows + new_position.y) % _rows)
	else:
		return current_position
