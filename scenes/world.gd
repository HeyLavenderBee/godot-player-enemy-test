extends Node2D

func _ready():
	if global.game_first_load_in == true:
		$Player.position.x = global.player_posx
		$Player.position.y = global.player_posy
	elif global.game_secret_load_in == true and global.game_first_load_in == false:
		$Player.position.x = global.player_exit_secret_posx
		$Player.position.y = global.player_exit_secret_posy
	elif global.game_bar_load_in == true and global.game_secret_load_in == false:
		$Player.position.x = global.player_exit_bar_posx
		$Player.position.y = global.player_exit_bar_posy
		
func _process(_delta):
	if global.found_mouse_cheese == true:
		$mouse_cheese.visible = false
	change_scene()
	bar_change_scene()

func _on_secret_transition_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func _on_secret_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false



func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/secretbase.tscn")
			global.game_first_load_in = false
			global.finish_changescenes()
			
func bar_change_scene():
	if global.bar_transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/morgan_bar.tscn")
			global.game_first_load_in = false
			global.bar_finish_changescenes()


func _on_bar_transition_body_entered(body):
	if body.has_method("player"):
		global.bar_transition_scene = true
		
		
func _on_bar_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false
