class_name PauseScreen extends Control

@onready var resume_btn: Button = get_node("Panel/ResumeButton")

func _ready() -> void:
	resume_btn.pressed.connect(on_resume)

# func _unhandled_input(_event: InputEvent) -> void:
# 	if Input.is_action_just_pressed("pause") and get_tree().paused:
# 		on_resume()

func on_resume() -> void:
	visible = false
	get_tree().paused = false