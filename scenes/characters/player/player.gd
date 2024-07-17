class_name Player extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

var can_transform: bool = false

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	speed = speed * 100

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if can_transform and event.is_action_pressed("transform_earth"):
		transform()

func entered_transform_area() -> void:
	can_transform = true

func exited_transform_area() -> void:
	can_transform = false

func transform() -> void:
	print("Player transformed to earth")