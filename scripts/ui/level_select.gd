class_name LevelSelect extends Control

@export var start_menu: String

@onready var back_btn: Button = get_node("Back")

var ui_path := "res://scenes/ui/"

func _ready() -> void:
	back_btn.pressed.connect(on_back_pressed)

func on_back_pressed():
	if start_menu:
		var full_path := ui_path + start_menu + ".tscn"
		get_tree().change_scene_to_file(full_path)
	else:
		printerr("No main menu scene set in level select screen")