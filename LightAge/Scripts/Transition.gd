extends Node2D

signal half_next_map

onready var colorRect = $ColorRect
onready var animationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	colorRect.visible = false

func to_scene(scene):
	colorRect.visible = true
	animationPlayer.play("glow_in")
	yield(animationPlayer,"animation_finished")
	get_tree().change_scene(scene)
	animationPlayer.play("glow_out")
	yield(animationPlayer,"animation_finished")
	colorRect.visible = false

func retry_map():
	animationPlayer.play("retry_level")

func next_map():
	animationPlayer.play("next_map")

func ending():
	animationPlayer.play("ending")

func _half_ending():
	get_tree().change_scene("res://Nodes/EndingScene.tscn")

func _half_next_map():
	emit_signal("half_next_map")
