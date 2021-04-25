extends Node2D

onready var aboutPopup = $Control/aboutPopup

# Called when the node enters the scene tree for the first time.
func _ready():
	GameController.load_game()
	_refresh_mute_icon()
	_refresh_continue_button()
	$Control/lblVersion.text = ProjectSettings.get("application/config/version")

func _on_btnAbout():
	aboutPopup.popup()

func _on_btnStart():
	GameController.set_last_level(-1)
	Transition.to_scene("res://Nodes/Game.tscn")

func _on_btnContinue_pressed():
	Transition.to_scene("res://Nodes/Game.tscn")

func _on_btnTwitter_pressed():
	OS.shell_open("https://twitter.com/rudyvic95")

func _on_btnWebsite_pressed():
	OS.shell_open("https://rudyvicario.altervista.org/")

func _on_btnItchio_pressed():
	OS.shell_open("https://rudyvic.itch.io/")

func _refresh_continue_button():
	var btn = $Control/btnContinue
	var _last_level = GameController.get_last_level()
	btn.text = "Continue (level " + str(_last_level+2) +")"
	if(_last_level != -1):
		btn.visible = true
	else:
		btn.visible = false

func _refresh_mute_icon():
	var btn = $btnMute
	if(GameController.get_is_muted()):
		btn.pressed = true
		btn.icon.set_region(Rect2(Vector2(32,0),Vector2(32,32)))
	else:
		btn.pressed = false
		btn.icon.set_region(Rect2(Vector2(0,0),Vector2(32,32)))

func _on_btnMute_pressed():
	var btn = $btnMute
	if(btn.pressed):
		GameController.set_is_muted(true)
	else:
		GameController.set_is_muted(false)
	_refresh_mute_icon()

