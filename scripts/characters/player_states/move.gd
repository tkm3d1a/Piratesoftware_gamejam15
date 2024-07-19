class_name Move extends State

@export var idle_state: State
@export var jump_state: State
@export var fall_state: State

func enter() -> void:
	super()

func exit() -> void:
	super()

func process_physics(_delta: float) -> State:
	var movement: float = Input.get_axis("move_left", "move_right") * parent.speed

	if movement == 0:
		return idle_state
	
	if not parent.is_on_floor():
		parent.start_coyote_timer()
		if not parent.coyote_buffer_active:
			return fall_state
	
	parent.velocity.x = movement
	parent.sprite_node.flip_h = movement < 0
	parent.move_and_slide()
	return null

func process_frame(_delta: float) -> State:
	return null

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and (parent.is_on_floor() or parent.can_jump):
		return jump_state

	if Input.is_action_just_pressed("transform_earth") and parent.can_transform:
		parent.transform(parent.Transform_State.EARTH)
	
	if Input.is_action_just_pressed("transform_base"):
		parent.transform(parent.Transform_State.BASE)
	
	return null