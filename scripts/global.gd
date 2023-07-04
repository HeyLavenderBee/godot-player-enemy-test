extends Node

var player_current_attack = false

@onready var player = get_node("player")

var current_scene = "world"
var transition_scene = false

var bar_transition_scene = false

var player_exit_secret_posx = 15
var player_exit_secret_posy = 55
var player_exit_bar_posx = 239
var player_exit_bar_posy = 9
var player_posx = 104
var player_posy = 71

var game_first_load_in = true
var game_bar_load_in = true
var game_secret_load_in = true

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "secret"
		else:
			current_scene = "world"
			
func bar_finish_changescenes():
	if bar_transition_scene == true:
		bar_transition_scene = false
		if current_scene == "world":
			current_scene = "bar"
		else:
			current_scene = "world"

var found_mouse_cheese = false
var give_mouse_cheese = false
