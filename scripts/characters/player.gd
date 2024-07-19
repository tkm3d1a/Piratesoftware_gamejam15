class_name Player extends CharacterBody2D

@export_group("Movement")
@export var speed := 300.0
@export var jump_velocity := 600.0
@export var jump_buffer_timer := 0.15
@export var coyote_wait_timer := 0.1

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
@onready var coyote_timer_node: Timer = get_node("CoyoteTimer")
@onready var jump_buffer_timer_node: Timer = get_node("JumpBufferTimer")

var jump_buffer_active := false
var coyote_buffer_active := false
var can_jump := true
var can_transform := true
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Debug things
@onready var DEBUG_state_label: Label = get_node("DEBUG_state")
var base_state_string: String = "State: "
@onready var DEBUG_transform_label: Label = get_node("DEBUG_transform")
var base_transform_string: String = "Element: "
@onready var DEBUG_c_label: Label = get_node("DEBUG_coyote")
var base_c_string: String = "Coyote: "
@onready var DEBUG_j_buffer_label: Label = get_node("DEBUG_jump_buffer")
var base_jb_string: String = "Jump Buffer: "

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
	d_update_c_label(coyote_buffer_active)
	d_update_jb_label(jump_buffer_active)
	state_machine.init(self)

	jump_buffer_timer_node.wait_time = jump_buffer_timer
	jump_buffer_timer_node.one_shot = true
	jump_buffer_timer_node.timeout.connect(clear_jump_buffer)

	coyote_timer_node.wait_time = coyote_wait_timer
	coyote_timer_node.one_shot = true
	coyote_timer_node.timeout.connect(on_coyote_timer_timeout)

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

func start_coyote_timer() -> void:
	coyote_buffer_active = true
	coyote_timer_node.start()
	d_update_c_label(coyote_buffer_active)

func on_coyote_timer_timeout() -> void:
	coyote_buffer_active = false
	d_update_c_label(coyote_buffer_active)

func start_jump_buffer() -> void:
	jump_buffer_active = true
	jump_buffer_timer_node.start()
	d_update_jb_label(jump_buffer_active)

func clear_jump_buffer() -> void:
	jump_buffer_active = false
	d_update_jb_label(jump_buffer_active)

##############################################################
# Debug only functions

func d_update_state_label(state_name: String) -> void:
		DEBUG_state_label.text = base_state_string + state_name

func d_update_transform_label(element: String) -> void:
	DEBUG_transform_label.text = base_transform_string + element

func d_update_c_label(c_timer_bool: bool) -> void:
	DEBUG_c_label.text = base_c_string + str(c_timer_bool)

func d_update_jb_label(jb_active_bool: bool) -> void:
	DEBUG_j_buffer_label.text = base_jb_string + str(jb_active_bool)