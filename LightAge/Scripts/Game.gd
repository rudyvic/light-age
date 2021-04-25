extends Node2D

signal next_level

onready var Map = preload("res://Nodes/Map.tscn")
onready var Enemy = preload("res://Nodes/Enemy.tscn")
onready var LabelPopup = preload("res://Nodes/LabelPopup.tscn")
onready var Player = $Player
onready var HUD = $HUD

var map

var _level: int
var _enemies: Array
var items_collected: int
var total_items: int
var NUM_LEVELS: int = 12

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.connect("hit",self,"retry_map")
	Player.connect("last_level_timer_ended",self,"next_level")
	_level = GameController.get_last_level()
	next_level()

func reset_items():
	items_collected = 0
	total_items = map.get_total_items()
	HUD.update_items_collected(items_collected,total_items)

func goal_reached():
	if items_collected>=total_items:
		$AudioStreamPlayerOk.play()
		next_level()
	else:
		$AudioStreamPlayerWrong.play()
		var l = LabelPopup.instance()
		add_child(l)
		l.show_text("Find all the items",Vector2(0,520))

func item_picked_up():
	items_collected += 1
	HUD.update_items_collected(items_collected,total_items)

func next_level():
	GameController.set_last_level(_level)
	_level += 1
	
	if _level > NUM_LEVELS:
		Transition.ending()
		return
	
	if _level <= 10:
		Player.set_light_size(clamp(1-(_level/10.0)*0.6,0.4,1.0))
	else:
		Player.set_light_size(0.4)
	
	if _level == NUM_LEVELS:
		Player.last_level()
	Player.position = Vector2.ZERO
	emit_signal("next_level")
	if map!=null:
#		map.call_deferred("queue_free")
		map.queue_free()
	for e in _enemies:
		e.queue_free()
		remove_child(e)
	_enemies = []
	Transition.next_map()
	yield(Transition,"half_next_map")
	HUD.set_level(_level+1)
	map = Map.instance()
	add_child(map)
	map.connect("goal_reached",self,"goal_reached")
	map.connect("item_picked_up",self,"item_picked_up")
	Player.position = map.load_map(_level)
	Player.spawn()
	for pos in map.enemy_positions:
		var enemy = Enemy.instance()
		add_child(enemy)
		enemy.position = pos
		_enemies.append(enemy)
	reset_items()
	
	# tutorials
	HUD.show_tutorial(map.get_tutorial(_level))
	
	# activate the items after a short delay
	$timerItem.start()
	

func retry_map():
	_level -= 1
	next_level()

func _on_Timer_timeout():
	map.activate_all_items()
	for e in _enemies:
		e.spawn()
