class_name Move extends State

@export var idle_state: State
@export var jump_state: State
@export var fall_state: State

var last_floor = false

func enter() -> void:
	super()

func exit() -> void:
	super()

func process_physics(_delta: float) -> State:
	var movement: float = Input.get_axis("move_left", "move_right") * parent.speed

	if movement == 0:
		return idle_state
	if not parent.is_on_floor():
		if parent.last_floor_status: # makes sure we are only starting the timer the frame after being on the floor
			parent.start_coyote_timer()
		if not parent.coyote_buffer_active:
			return fall_state

	if parent.jump_buffer_active and parent.is_on_floor():
		return jump()
	
	parent.velocity.x = movement
	parent.sprite_node.flip_h = movement < 0
	parent.last_floor_status = parent.is_on_floor() # need to reset the 'last floor' BEFORE moving the character
	parent.move_and_slide()
	return null

func process_frame(_delta: float) -> State:
	return null

func process_input(_event: InputEvent) -> State:
	if parent.can_transform:
		if Input.is_action_just_pressed("transform_earth"):
			parent.transform(parent.Transform_State.EARTH)
		
		if Input.is_action_just_pressed("transform_wind"):
			parent.transform(parent.Transform_State.WIND)

		if Input.is_action_just_pressed("transform_water"):
			parent.transform(parent.Transform_State.WATER)

		if Input.is_action_just_pressed("transform_fire"):
			parent.transform(parent.Transform_State.FIRE)
	
	if Input.is_action_just_pressed("transform_base"):
		parent.transform(parent.Transform_State.BASE)

	if Input.is_action_just_pressed("jump") and (parent.is_on_floor() or parent.can_jump):
		return jump_state
	
	return null

func jump() -> State:
	parent.clear_jump_buffer()
	return jump_state