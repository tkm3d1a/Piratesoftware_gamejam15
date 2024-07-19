class_name Player extends CharacterBody2D

@export_group("Movement")
@export var speed = 300.0
@export var jump_velocity = 400.0

@export_group("Transformations")
@export var current_transform_state: Transform_State = Transform_State.BASE
@export var base_sprites: Texture2D
@export var earth_sprites: Texture2D
@export var wind_sprites: Texture2D
@export var water_sprites: Texture2D
@export var fire_sprites: Texture2D

@onready var state_machine: StateMachine = get_node("StateMachine")
@onready var anim_player_node: AnimationPlayer = get_node("AnimationPlayer")
@onready var sprite_node: Sprite2D = get_node("Sprite2D")

# Debug things
@onready var DEBUG_state_label: Label = get_node("DEBUG_state")
var base_state_string: String = "State: "
@onready var DEBUG_transform_label: Label = get_node("DEBUG_transform")
var base_transform_string: String = "Element: "

var can_transform: bool = true
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

enum Transform_State {
	BASE,
	EARTH,
	WATER,
	WIND,
	FIRE
}

func _ready() -> void:
	# speed = speed * 100
	d_update_transform_label(Transform_State.keys()[current_transform_state])
	state_machine.init(self)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	#TODO: Move below to handle inside state machine?
	# if can_transform:
	# 	if event.is_action_pressed("transform_earth"):
	# 		transform(Transform_State.EARTH)

	# if event.is_action_pressed("transform_base"):
	# 	transform(Transform_State.BASE)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func entered_transform_area() -> void:
	can_transform = true

func exited_transform_area() -> void:
	can_transform = false

func transform(to_state: Transform_State) -> void:
	if to_state == current_transform_state:
		return

	match to_state:
		Transform_State.EARTH:
			sprite_node.texture = earth_sprites
			# can_transform = false
			current_transform_state = Transform_State.EARTH
			d_update_transform_label(Transform_State.keys()[current_transform_state])
		Transform_State.BASE:
			sprite_node.texture = base_sprites
			current_transform_state = Transform_State.BASE
			d_update_transform_label(Transform_State.keys()[current_transform_state])
		_:
			print("Default transform match case")

##############################################################
# Debug only functions

func d_update_state_label(state_name: String) -> void:
		DEBUG_state_label.text = base_state_string + state_name

func d_update_transform_label(element: String) -> void:
	DEBUG_transform_label.text = base_transform_string + element