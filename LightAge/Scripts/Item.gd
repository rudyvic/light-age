extends Sprite

signal item_picked_up

var _pickable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_pickable(value: bool):
	_pickable = value

func _on_Area2D_body_entered(body):
	if body.name == "Player" and _pickable:
		_pickable = false
		$AudioStreamPlayer.play()
		$Item.visible = false
		call_deferred("emit_signal","item_picked_up")
		$Area2D/CollisionShape2D.set_deferred("disabled",true)
