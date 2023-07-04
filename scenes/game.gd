extends Node #game script, where all the nodes are

@onready var text = $ui/Health_panel/text_hp2
@onready var player = $Player

func _ready():
	player.health_changed.connect(text.update_health)
	text.update_health(player.health)

func _process(delta):
	pass

