extends KinematicBody2D

var gravity = 35
var acceleration = 3000
var deacceleration = 3000
var max_speed = 150
var max_sprint_speed = 250
var friction = 2000
var jump_height = 400

onready var sprite = get_node("Sprite")
onready var timer = get_node("Timer")
onready var animation = get_node("AnimationPlayer")
#onready var state_machine = get_node("AnimationTree").get("parameters/playback")

var action
var jump_count
var motion = Vector2()
var hSpeed = 0
var air = false

func _ready():
	animation.play("idle")
	action = null
	timer.wait_time = 0.1
	timer.one_shot = true

func _unhandled_input(event):
#	if event.is_action_pressed("interact"):
#		if action != null and self.visible:
#			action.activate()
#			if action.is_in_group("hide"):
#				self.hide()
#		elif self.visible == false:
#			show()
	
	if event.is_action_pressed("interact"):
		if action != null:
			action.activate()
			if action.is_in_group("hide"):
				self.visible = !self.visible
				hSpeed = 0
				global_position.x = action.global_position.x

func movement(var delta):
	if Input.is_action_pressed("ui_down"):
		animation.play("crouch")
		sprite.scale = Vector2(1.1, 0.9)
		hSpeed -= min(abs(hSpeed), friction * delta) * sign(hSpeed)
	elif Input.is_action_pressed("ui_right"):
		animation.play("walk")
		if Input.is_action_pressed("sprint"):
			if(hSpeed <-100):
				hSpeed += (deacceleration * delta)
			elif(hSpeed < max_sprint_speed):
				hSpeed += (acceleration * delta)
				sprite.flip_h = true
		else:
			if(hSpeed <-100):
				hSpeed += (deacceleration * delta)
			elif(hSpeed < max_speed):
				hSpeed += (acceleration * delta)
				sprite.flip_h = true
			else:
				hSpeed = max_speed
	elif Input.is_action_pressed("ui_left"):
		animation.play("walk")
		if Input.is_action_pressed("sprint"):
			if(hSpeed > 100):
				hSpeed -= (deacceleration * delta)
			elif(hSpeed > -max_sprint_speed):
				hSpeed -= (acceleration * delta)
				sprite.flip_h = false
		else:
			if(hSpeed > 100):
				hSpeed -= (deacceleration * delta)
			elif(hSpeed > -max_speed):
				hSpeed -= (acceleration * delta)
				sprite.flip_h = false
			else:
				hSpeed = -max_speed
	else:
		animation.play("idle")
		hSpeed -= min(abs(hSpeed), friction * delta) * sign(hSpeed)

func _physics_process(delta):
	if visible == false:
		return
	
	motion.y += gravity
	
	movement(delta)
	if !is_on_floor():
		air = true
	if is_on_floor():
		if air:
			sprite.scale = Vector2(1.1, 0.9)
		air = false
		jump_count = 1
	if Input.is_action_just_pressed("ui_up"):
		sprite.scale = Vector2(0.9, 1.1)
		timer.start()

	if timer.get_time_left() > 0.0 and jump_count != 0:
		motion.y = -jump_height
		jump_count-=1
	
	motion.x = hSpeed
	motion = move_and_slide(motion,Vector2(0,-1))
	
	sprite.scale.x = lerp(sprite.scale.x, 1, 0.2)
	sprite.scale.y = lerp(sprite.scale.y, 1, 0.2)

func _on_Interact_area_entered(area):
	if is_on_floor():
		if area.name != "Hurtbox":
			action = area
			print(action)

func _on_Interact_area_exited(area):
	action = null
