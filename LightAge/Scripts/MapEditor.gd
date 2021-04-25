extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func load_map(level) -> Array:
	var res_map = Array()
	var lvl = get_child(level)
	var map = lvl.get_used_cells()
	var map_size_y = 0
	var map_size_x = 0
	for i in map:
		if i.x > map_size_x:
			map_size_x = i.x
		if i.y > map_size_y:
			map_size_y = i.y
	res_map.resize(map_size_x+1)
	for i in range(0,res_map.size()):
		res_map[i] = Array()
		res_map[i].resize(map_size_y+1)
		for j in range(0,res_map[i].size()):
			var cell = lvl.get_cellv(Vector2(i,j))
			if cell == -1:
				cell = 0
			res_map[i][j] = cell
	return res_map

func get_tutorial_for_level(level: int) -> Node:
	if get_child(level).get_child_count() > 0:
		return get_child(level).get_child(0).duplicate()
	return null

