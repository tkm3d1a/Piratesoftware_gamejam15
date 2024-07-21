class_name StartMenu extends Control

@export var start_level: String
@export var level_select: String
@export var base_player: PackedScene

@onready var start_btn: Button = get_node("StartGame")
@onready var lvl_select_btn: Button = get_node("LevelSelect")
@onready var settings_btn: Button = get_node("Settings")
@onready var quit_btn: Button = get_node("QuitGame")

var levels_path := "res://scenes/levels/"
var ui_path := "res://scenes/ui/"

func _ready() -> void:
	start_btn.pressed.connect(start_game)
	lvl_select_btn.pressed.connect(level_select_screen)
	quit_btn.pressed.connect(quit_game)

	if base_player:
		if game_manager.player == null:
			var i_player := base_player.instantiate()
			game_manager.player = i_player
	else:
		printerr("No base player set from start menu - start button and level select button disabled")
		start_btn.disabled = true
		lvl_select_btn.disabled = true

func start_game():
	if start_level:
		var full_path := levels_path + start_level + ".tscn"
		get_tree().change_scene_to_file(full_path)
	else:
		printerr("No start level scene set")

func level_select_screen():
	if level_select:
		var full_path := ui_path + level_select + ".tscn"
		get_tree().change_scene_to_file(full_path)
	else:
		printerr("No level select scene set")

func quit_game() -> void:
	get_tree().quit()