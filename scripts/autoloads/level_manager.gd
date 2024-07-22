extends Node

func on_pause_pressed() -> void:
	var pause_node: Node = get_tree().get_first_node_in_group("pause")
	if pause_node:
		if pause_node is PauseScreen:
			get_tree().paused = true
			pause_node.show()
