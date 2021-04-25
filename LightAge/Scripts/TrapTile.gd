extends Sprite

enum States {
	IDLE = 0,
	READY,
	ATTACK,
}

onready var spikes = $Spikes
var _state = States.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	$Spikes.play("idle")


func _on_Timer_timeout():
	if _state == States.IDLE:
		$AnimationPlayer.play("ready")
		_state = States.READY
		$Timer.start(2)
	elif _state == States.READY:
		$AnimationPlayer.play("attack")
		_state = States.ATTACK
		$Timer.start(1)
	elif _state == States.ATTACK:
		$AnimationPlayer.play("idle")
		_state = States.IDLE
		$Timer.start(4)


func _on_Area2D_body_entered(body):
	if _state != States.ATTACK:
		return
	
	if body.has_method("hit"):
			body.hit()
