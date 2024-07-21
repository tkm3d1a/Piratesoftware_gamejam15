extends BaseLevel

func _ready() -> void:
	super()
	if game_manager.player:
		player = game_manager.player
		player.global_position = starting_point.global_position
		add_child(player)
