extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null
var health = 100
var player_inattack_range = false
var can_take_damage = true
var enemy_can_attack = false

func _ready():
	$AnimatedSprite2D.play("mouse_idle_anim")

func _physics_process(_delta):
	update_health()
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/speed
		
		$AnimatedSprite2D.play("mouse_walk_anim")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
			#if u compare to the video, ur gonna see that the false and true are inverted
			#cuz i drew my sprites the oposite way lol
		

func _on_detect_area_body_entered(body):
	player = body
	if health == 100:
		$CollisionShape2D.disabled = true
		global.player_current_attack = false
		player_chase = false
		enemy_can_attack = false
	else:
		enemy_can_attack = true
		player_chase == true
		global.player_current_attack = true
		$CollisionShape2D.disabled = false
	

func _on_detect_area_body_exited(_body):
	$AnimatedSprite2D.play("mouse_idle_anim")
	player = null
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_range = true
	
func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_range = false


func deal_with_damage():
	if player_inattack_range and global.player_current_attack == true:
		if can_take_damage == true:
			$take_damage_cooldown.start()
			can_take_damage = false
			health -= 20
			player_chase = true
			enemy_can_attack = true
			print("enemy health = ", health)
		elif health <=0:
			player_chase = false
			$AnimatedSprite2D.play("death_anim")
			self.queue_free()


func _on_take_damage_cooldown_timeout():
	can_take_damage = true

func update_health():
	var healthbar = $enemy_healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_enemy_regen_time_timeout():
	if health < 100:
		if global.player_current_attack == false or player_chase == false:
			health += 20
			print("Enemy regen!", health)
		if health > 100:
			health = 100
		if health == 100:
			print("Enemy full!")
	if health <= 0: # this is because the timer cant work when the health is equal to zero
		health = 0
