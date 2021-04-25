extends KinematicBody2D

var run_speed = 50
var velocity = Vector2.ZERO
var _state = "IDLE"
var _player = null
var _player_near = false
var _prev_collision = null
var _is_ready = false

func _ready():
	velocity = Vector2.ZERO
	_state = "IDLE"
	_player = null
	_player_near = false
	_prev_collision = null
	$AnimatedSprite.play("idle")
	randomize()

func spawn():
	velocity = Vector2.ZERO
	set_ready(true)
	$Timer.start()

func _process(delta):
	$lblDebugState.text = _state

func get_input():
	if _state == "CHASE":
		return
	velocity.x = rand_range(-1,1)
	velocity.y = rand_range(-1,1)
	velocity = velocity.normalized() * run_speed

func _physics_process(delta):
	if !_is_ready:
		velocity = Vector2.ZERO
		return
	
	if _state == "CHASE":
		velocity = global_position.direction_to(_player.global_position)
		velocity = velocity.normalized() * run_speed
		$RayCast2D.rotation_degrees = velocity.angle() * 360 / 6.28
	
	if _prev_collision != null:
		velocity = velocity.slide(_prev_collision.normal).normalized() * run_speed
		_prev_collision = null
	velocity = move_and_slide(velocity)
	var slide_count = get_slide_count()
	if slide_count:
		var collision = get_slide_collision(slide_count - 1)
		var collider = collision.collider
#	var collision = move_and_collide(velocity * delta)
		if collision:
	#		velocity = velocity.bounce(collision.normal)
			_prev_collision = collision
#			velocity = velocity.slide(collision.normal).normalized() * run_speed
#			print(velocity)
	#		velocity = Vector2.ZERO
			if collision.collider.name == "Player":
				collision.collider.hit()
			get_input()
			$Timer.start()
	
	if velocity!=Vector2.ZERO:
		$AnimatedSprite.play("walk")
		$AnimatedSprite.rotation_degrees = velocity.angle_to_point(Vector2.ZERO) * 360/6.28
	else:
		$AnimatedSprite.play("idle")
	
	if _state == "CHASE" and !_player_near:
		if $RayCast2D.is_colliding():
			if $RayCast2D.get_collider().name != "Player":
				_unchase_player()


func _on_Timer_timeout():
	get_input()


func _on_DetectionArea_body_entered(body):
	if body.name == "Player":
		_player = body
		_state = "CHASE"
		_player_near = true


func _on_DetectionArea_body_exited(body):
	if body.name == "Player":
		_player_near = false

func _on_ExitArea_body_exited(body):
	if body.name == "Player":
		_unchase_player()

func _unchase_player():
	_player = null
	_state = "IDLE"
	get_input()

func set_ready(value: bool):
	_is_ready = value

func hit():
	_is_ready = false
	$AnimatedSprite.play("dead")
	$AudioStreamPlayer.play()
	$CollisionShape2D.set_deferred("disabled",true)
