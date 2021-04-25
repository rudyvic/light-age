extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$lbl.visible = false

func show_text(text: String, global_position: Vector2):
	$lbl.text = text
	$lbl.set_global_position(global_position)
	$lbl.visible = true
	$AnimationPlayer.play("show")
	yield($AnimationPlayer,"animation_finished")
	self.call_deferred("queue_free")
