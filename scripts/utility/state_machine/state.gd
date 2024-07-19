class_name State extends Node

@export var animation_name: String

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var parent: Player

func enter() -> void:
	parent.anim_player_node.play(animation_name)
	parent.d_update_state_label(self.name)

func exit() -> void:
	parent.anim_player_node.stop()

func process_physics(_delta: float) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_input(_event: InputEvent) -> State:
	return null