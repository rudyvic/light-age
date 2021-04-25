extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("ending")


func _main_menu():
	GameController.set_last_level(-1)
	Transition.to_scene("res://Nodes/MainMenu.tscn")
