extends KinematicBody2D

signal hit
signal last_level_timer_ended

var run_speed = 180
var velocity = Vector2()
var _is_ready = false

func spawn():
	$AnimationPlayer.play("spawn")
	$AnimatedSprite.play("idle")
	$CollisionShape2D.disabled = false
	_is_ready = false
	yield($AnimationPlayer,"animation_finished")
	_is_ready = true

func get_input():
	if !_is_ready:
		velocity = Vector2(0,0)
		return
	
	velocity.x = 0
	velocity.y = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var up = Input.is_action_pressed('ui_up')
	var down = Input.is_action_pressed("ui_down")

	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed
	if up:
		velocity.y -= run_speed
	if down:
		velocity.y += run_speed
	velocity = velocity.normalized() * run_speed

func _physics_process(delta):
	if _is_ready:
		get_input()
		velocity = move_and_slide(velocity)
		if velocity!=Vector2.ZERO:
			$AnimatedSprite.play("walk")
			$AnimatedSprite.rotation_degrees = velocity.angle_to_point(Vector2.ZERO) * 360/6.28
		else:
			$AnimatedSprite.play("idle")

func hit():
	_is_ready = false
	$AnimatedSprite.play("dead")
	$AudioStreamPlayer.play()
	$CollisionShape2D.set_deferred("disabled",true)
	$timerDead.start()

func set_light_size(value):
	$LightOn.scale = Vector2(value,value)
	$LightOff.scale = Vector2(value,value)

func _on_timerDead_timeout():
	emit_signal("hit")

func last_level():
	$AnimationPlayerLastLevel.play("last_level")
	yield($AnimationPlayerLastLevel,"animation_finished")
	emit_signal("last_level_timer_ended")
