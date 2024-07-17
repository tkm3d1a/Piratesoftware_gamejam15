class_name Player extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

@export var current_transform_state: Transform_State = Transform_State.BASE

@onready var anim_player_node: AnimationPlayer = get_node("AnimationPlayer")

var can_transform: bool = false
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

enum Transform_State {
	BASE,
	EARTH,
	WATER,
	WIND,
	FIRE
}

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
	if can_transform:
		if event.is_action_pressed("transform_earth"):
			transform(Transform_State.EARTH)

	if event.is_action_pressed("transform_base"):
		transform(Transform_State.BASE)

func entered_transform_area() -> void:
	can_transform = true

func exited_transform_area() -> void:
	can_transform = false

func transform(to_state: Transform_State) -> void:
	if not to_state != current_transform_state:
		return

	match to_state:
		Transform_State.EARTH:
			print("Player transformed to earth")
			anim_player_node.play("transform_earth")
			can_transform = false
		Transform_State.BASE:
			print("Player transformed to base")
			current_transform_state = Transform_State.BASE
		_:
			print("Default transform match case")