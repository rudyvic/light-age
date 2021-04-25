extends Node2D

signal goal_reached
signal item_picked_up

var Tile = load("res://Nodes/Tile.tscn")
var Wall = load("res://Nodes/Wall.tscn")
var GoalTile = load("res://Nodes/GoalTile.tscn")
var StartTile = load("res://Nodes/StartTile.tscn")
var ItemTile = load("res://Nodes/ItemTile.tscn")
var TrapTile = load("res://Nodes/TrapTile.tscn")
onready var MapEditor = $MapEditor

var enemy_positions = []
var item_tiles = []

var _number_of_items = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func load_map(level):
	var start_tile = null
	enemy_positions = []
	item_tiles = []
	_number_of_items = 0
	var map = MapEditor.load_map(level)
	for i in range(0,map.size()):
		for j in range(0,map[i].size()):
			var t
			var m = map[i][j]
			
			if m == 0:
				t = Tile.instance()
			elif m == 1:
				t = Wall.instance()
			elif m == 2:
				t = StartTile.instance()
				start_tile = t
			elif m == 3:
				t = GoalTile.instance()
				t.connect("goal_reached",self,"goal_reached")
			elif m == 4:
				t = ItemTile.instance()
				item_tiles.append(t)
				_number_of_items += 1
				t.connect("item_picked_up",self,"item_picked_up")
			elif m == 5:
				t = Tile.instance()
				enemy_positions.append(Vector2(32+i*64,32+j*64))
			elif m == 6:
				t = TrapTile.instance()
			add_child(t)
			t.z_as_relative = false
			t.z_index = 1
			t.position = Vector2(32+i*64,32+j*64)
			map[i][j] = t
	
	return start_tile.position

func goal_reached():
	emit_signal("goal_reached")

func item_picked_up():
	emit_signal("item_picked_up")

func get_total_items():
	return _number_of_items

func activate_all_items():
	for i in item_tiles:
		i.set_pickable(true)

func get_tutorial(_level: int) -> Control:
	return (MapEditor.get_tutorial_for_level(_level) as Control)

