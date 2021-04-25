extends CanvasLayer

onready var _lblItemsCollected = $lblItemsCollected
onready var _popupPause = $PopupPause

# Called when the node enters the scene tree for the first time.
func _ready():
	_refresh_mute_icon()

func update_items_collected(items_collected,total_items):
	_lblItemsCollected.text = str(items_collected,"/",total_items)

func show_tutorial(tutorial: Control):
	if $tutorials.get_child_count() > 0:
		$tutorials.get_child(0).queue_free()
	if tutorial != null:
		$tutorials.add_child(tutorial)

func _on_btnPause_pressed():
	_popupPause.popup()
	get_tree().paused = true

func _on_btnMainMenu_pressed():
	get_tree().paused = false
	_popupPause.hide()
	Transition.to_scene("res://Nodes/MainMenu.tscn")

func _on_btnContinue_pressed():
	_popupPause.hide()
	get_tree().paused = false

func _refresh_mute_icon():
	var btn = $PopupPause/Control/btnMute
	if(GameController.get_is_muted()):
		btn.pressed = true
		btn.icon.set_region(Rect2(Vector2(32,0),Vector2(32,32)))
	else:
		btn.pressed = false
		btn.icon.set_region(Rect2(Vector2(0,0),Vector2(32,32)))

func _on_btnMute_pressed():
	var btn = $PopupPause/Control/btnMute
	if(btn.pressed):
		GameController.set_is_muted(true)
	else:
		GameController.set_is_muted(false)
	_refresh_mute_icon()

func set_level(l: float):
	$lblLevel.text = "Level " + str(l)
