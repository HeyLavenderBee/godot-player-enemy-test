extends CharacterBody2D #player script

var enemy_inattack_range = false
var enemy_attack_cooldown = true

@export var health = 200:
	set(value):
		health = value
	# A signal can carry information too, such as health
		emit_signal("health_changed", health)

signal health_changed(health)

var player_alive = true
var attack_ip = false
var dialogue_on = false

var in_cheese_detec = false

const speed = 60
var current_dir = "none"

func _ready():
	print(health)
	$AnimatedSprite2D.play("side_idle_animation")

func _physics_process(delta):
		
	if in_cheese_detec == true:
		if Input.is_action_just_pressed("ui_accept"):
			global.found_mouse_cheese = true
	
	if enemy_inattack_range == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "main")
			dialogue_on = true
			return
			
	player_movement(delta)
	enemy_attack()
	attack()
	change_camera()
	update_health()
	
	if health<=0:
		player_alive = false #add endscreen
		health = 0
		print("player died")
		self.queue_free() #this is for the player to disappear
	
func player_movement(_delta):
	
	if Input.is_action_pressed("move_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("move_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("move_up"): #like in python, the up and down is inverted, so up is down and down is up
		current_dir = "up"	
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("move_down"):
		current_dir = "down"		
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	else: # if nothing is being pressed
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk_animation")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle_animation")
	if dir == "left":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk_animation")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle_animation")
				
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk_animation")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle_animation")
	
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk_animation")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle_animation")

func player():
	pass

func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
		
func enemy_attack():
	if enemy_attack_cooldown == true and enemy_inattack_range == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)
		emit_signal("health_updated", health)
		
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		if Input.is_action_just_pressed("ui_accept") == false:
			global.player_current_attack = true
			attack_ip = true
			if dir == "right":
				$AnimatedSprite2D.flip_h = true
				$AnimatedSprite2D.play("attack_anim")
				$deal_attack_timer.start()
			if dir == "left":
				$AnimatedSprite2D.flip_h = false
				$AnimatedSprite2D.play("attack_anim")
				$deal_attack_timer.start()
			if dir == "up":
				$AnimatedSprite2D.play("attack_anim")
				$deal_attack_timer.start()
			if dir == "down":
				$AnimatedSprite2D.play("attack_anim")
				$deal_attack_timer.start()


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false
	
func change_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$secret_camera.enabled = false
		$bar_camera.enabled = false
	elif global.current_scene == "secret":
		$world_camera.enabled = false
		$secret_camera.enabled = true
		$bar_camera.enabled = false
	elif global.current_scene == "bar":
		$world_camera.enabled = false
		$secret_camera.enabled = false
		$bar_camera.enabled = true
		
func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 200:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_time_timeout(): #this thing of regen health works fine
	if health < 200:
		if global.player_current_attack == false:
			health += 20
			print("Health regenerated!", health)
		if health > 200:
			health = 200
		if health == 200:
			print("Full health!")
	if health <= 0:
		health = 0


func _on_cheese_detec_body_entered(body):
	if body.has_method("player"):
		in_cheese_detec = true


func _on_cheese_detec_body_exited(body):
	if body.has_method("player"):
		in_cheese_detec = false
		

